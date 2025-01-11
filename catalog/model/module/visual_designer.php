<?php

namespace Opencart\Catalog\Model\Extension\VisualDesigner\Module;

class VDBlockLoader
{
    private $registry;
    public function __construct($registry)
    {
        $this->registry = $registry;
    }

    public function load($type, $method, $args)
    {
        if (!$this->registry->has('block_visual_designer_'.$type)) {
            if (is_file(DIR_EXTENSION.'visual_designer/catalog/controller/visual_designer_module/'.$type.'.php')) {

                $class = 'Opencart\\Catalog\\Controller\\Extension\\VisualDesigner\\VisualDesignerModule\\' . str_replace('_', '', ucwords($type, '_'));
                $block_class = new $class ($this->registry);
                $this->registry->set('block_visual_designer_'.$type, $block_class);
            } else if (is_file(DIR_EXTENSION.'visual_designer_module/catalog/controller/visual_designer_module/'.$type.'.php')) {
				$class = 'Opencart\\Catalog\\Controller\\Extension\\VisualDesignerModule\\VisualDesignerModule\\' . str_replace('_', '', ucwords($type, '_'));
				if (!class_exists($class)) require DIR_EXTENSION . 'visual_designer_module/catalog/controller/visual_designer_module/'.$type.'.php';
                $block_class = new $class ($this->registry);
                $this->registry->set('block_visual_designer_'.$type, $block_class);
			} else if (is_file(DIR_EXTENSION.'visual_designer_landing/catalog/controller/visual_designer_module/'.$type.'.php')) {
				$class = 'Opencart\\Catalog\\Controller\\Extension\\VisualDesignerLanding\\VisualDesignerModule\\' . str_replace('_', '', ucwords($type, '_'));
				if (!class_exists($class)) require DIR_EXTENSION . 'visual_designer_landing/catalog/controller/visual_designer_module/'.$type.'.php';
                $block_class = new $class ($this->registry);
                $this->registry->set('block_visual_designer_'.$type, $block_class);
			} else {
                return false;
            }
        }

        $output = false;
        if (method_exists($this->registry->get('block_visual_designer_'.$type), $method)) {
            $output = $this->registry->get('block_visual_designer_'.$type)->$method($args);
        }

        return $output;
    }
}
class VisualDesigner extends \Opencart\System\Engine\Model
{
    private $codename = 'visual_designer';

    private $error = array();

    private $sort = 'name';

    private $order = 'ASC';

    private $styles = array();

    private $styleContent = '';

	private $stylesContent = '';

    public function __construct($registry)
    {
        parent::__construct($registry);
        $this->load->model('tool/image');
        $this->load->model('setting/setting');
        $this->registry->set('vd_block', new VDBlockLoader($registry));
    }

    /**
     * Converts shortcodes to settings
     */
    public function parseContent($text)
    {
        $blocks = $this->getBlocks();

        $d_shortcode_reader_writer = new \Opencart\System\Library\Extension\DvShortcodeReaderWriter\DvShortcodeReaderWriter($blocks);

        $setting = $d_shortcode_reader_writer->readShortcode($text);

        if (!empty($text) && empty($setting)) {
            $text = "[vd_row][vd_column][vd_text text='".$d_shortcode_reader_writer->escape($text)."'][/vd_column][/vd_row]";
            $setting = $d_shortcode_reader_writer->readShortcode($text);
        }

        $setting = $this->checkCompability($setting);

        $that = $this;
        array_walk($setting, function (&$block, $key) use ($that) {
            $block['setting'] = $that->getSetting($block['setting'], $block['type']);
        });

        return $setting;
    }

    public function checkCompability($setting)
    {
        $resSetting = $setting;

        $blocks = $this->getBlocksByParent('', $setting);

        foreach($blocks as $block_id => $block_info) {
            if($block_info['type'] == 'row') {
                $new_block = $this->newBlock('section_wrapper');
                $new_block['sort_order'] = $block_info['sort_order'];
                $resSetting[$new_block['id']] = $new_block;
                $resSetting[$block_id]['parent'] = $new_block['id'];
            }
        }

        return $resSetting;
    }

    public function newBlock($type)
    {
        $setting = $this->getSettingBlock($type);

        return array(
            'id' => $type.'_'.substr( md5(rand()), 0, 7),
            'parent' => '',
            'type' => $type,
            'setting' => $setting['setting']
        );
    }

    /**
     * Converts settings to shortcodes
     */
    public function parseSetting($setting)
    {
        if (empty($setting)) {
            return '';
        }

        $blocks = $this->getBlocks();

        $that = $this;
        array_walk($setting, function (&$block, $key) use ($that) {
            $block['setting'] = $block['setting']['global'];
        });

        $d_shortcode_reader_writer = new \Opencart\System\Library\Extension\DvShortcodeReaderWriter\DvShortcodeReaderWriter($blocks);

        $content = $d_shortcode_reader_writer->writeShortcode($setting);

        return $content;
    }

    /**
     * Returns the shortcodes for the specified config
     */
    public function getContent($route, $id, $field_name)
    {
        $query = $this->db->query("SELECT `content` FROM `".DB_PREFIX."visual_designer_content` WHERE `route` ='".$route."' AND `id` = '".(int)$id."' AND `field` = '".$field_name."'");

        return $query->row;
    }
    /**
     * Keeps shortcodes in the database
     */
    public function saveContent($content, $route, $id, $field_name)
    {
        $query = $this->db->query("SELECT * FROM `".DB_PREFIX."visual_designer_content` WHERE `route` ='".$route."' AND `id` = '".(int)$id."' AND `field` = '".$field_name."'");

        if ($query->num_rows) {
            $this->db->query("UPDATE `".DB_PREFIX."visual_designer_content` SET `content`= '".$this->db->escape($content)."' WHERE `route` ='".$route."' AND `id` = '".(int)$id."' AND `field` = '".$field_name."'");
        } else {
            $this->db->query("INSERT INTO `".DB_PREFIX."visual_designer_content` SET `content`= '".$this->db->escape($content)."', `route` ='".$route."', `id` = '".(int)$id."', `field` = '".$field_name."'");
        }
    }

    /**
     * Converts shortcodes to text
     * @param $setting
     * @return string
     */
    public function getText($setting)
    {
        $content = $this->preRenderLevel('', $setting, true);
        $styles = '<style type="text/css">';

        if (!empty($this->styles)) {
            foreach ($this->styles as $style) {
                $handle = fopen(DIR_OPENCART.$style, "r");
                $contents = fread($handle, filesize(DIR_OPENCART.$style));
                $styles .= $contents;
            }
        }
        $styles .= '</style>';

        $content = $content.$styles;

        return $content;
    }

    /**
     * Full Pre-render
     * @param $setting
     * @param $content
     * @return string
     * @throws Exception
     */
    public function preRender($setting, $content)
    {
        $md5_data = array(
            'content' => $content,
            'language_id' => $this->config->get('config_language_id'),
            'route' => !empty($this->request->get['route'])? $this->request->get['route']:'common/home'
        );
        $this->stylesContent = '';
        $hash = md5(json_encode($md5_data));

        $result = $this->cache->get('vd-pre-render.' . $hash);
        if (!$result) {
            $result = $this->preRenderLevel('', $setting, false);
            $result .= '<style type="text/css">';
            $result .= $this->stylesContent;
            $result .= '</style>';
            $this->cache->set('vd-pre-render.' .$hash, $result);
        }

        return $result;
    }

    public function getOptions($type, $permission) {
        return $this->vd_block->load($type, 'options', $permission);
    }

    /**
     * Pre-render content from settings by Parent ID
     * @param $parent
     * @param $setting
     * @param bool $html
     * @return string
     * @throws Exception
     */
    public function preRenderLevel($parent, $setting, $html = false)
    {
        $blocks = $this->getBlocksByParent($parent, $setting);
        $result = '';
        foreach ($blocks as $block_info) {
            $block_config = $this->getSettingBlock($block_info['type']);

            //Full Pre-render
            $fullPreRender = !empty($block_config['pre_render']) && !$html;
            //Save to HTML
            $saveToHtml = !empty($block_config['pre_render']) && !empty($block_config['save_html']) && $html;

            if ($fullPreRender || $saveToHtml) {
                $renderData = array(
                    'setting' => $block_info['setting'],
                    'local' => $this->vd_block->load($block_info['type'], 'local', false),
                    'options' => $this->vd_block->load($block_info['type'], 'options', false),
                    'children' => $this->preRenderLevel($block_info['id'], $setting),
                    'id' => $block_info['id']
                );

				if (is_file(DIR_EXTENSION . 'visual_designer/catalog/controller/visual_designer_module/'.$block_info['type'] . '.php')) {
					$result .= $this->load->view('extension/visual_designer/visual_designer_module/'.$block_info['type'], $renderData);
				} else if (is_file(DIR_EXTENSION . 'visual_designer_module/catalog/controller/visual_designer_module/'.$block_info['type'] . '.php')) {
					$result .= $this->load->view('extension/visual_designer_module/visual_designer_module/'.$block_info['type'], $renderData);
				} else if (is_file(DIR_EXTENSION . 'visual_designer_landing/catalog/controller/visual_designer_module/'.$block_info['type'] . '.php')) {
					$result .= $this->load->view('extension/visual_designer_landing/visual_designer_module/'.$block_info['type'], $renderData);
				}


                $output = $this->vd_block->load($block_info['type'], 'styles', false);

                $styles = $this->load->view('extension/visual_designer/visual_designer/partials/layout_style', $block_info);

                $styles = preg_replace('/\/\*((?!\*\/).)*\*\//', '', $styles);
                $styles = preg_replace('/\s{2,}/', ' ', $styles);
                $styles = preg_replace('/\s*([:;{}])\s*/', '$1', $styles);
                $styles = preg_replace('/;}/', '}', $styles);

                $this->stylesContent .= $styles;

                if (is_array($output)) {
                    $this->styles =array_merge($this->styles, $output);
                }
            } else {
                $result .= '';
            }
        }
        return $result;
    }

    /**
     * Get list blocks by Parent ID
     * @param $parent
     * @param $setting
     * @return array
     */
    public function getBlocksByParent($parent, $setting)
    {
        return array_filter($setting, function ($value) use ($parent) {
            return $value['parent'] == $parent;
        });
    }

    public function parseResult($data, &$page_data)
    {
        if (!empty($page_data['header'])) {
            if (
                !class_exists('\\Opencart\\System\\Library\\Extension\\DvSimpleHtmlDom\\DvSimpleHtmlDom') && 
                is_file(DIR_EXTENSION . 'dv_simple_html_dom/system/library/dv_simple_html_dom.php')
            ) {
                require_once DIR_EXTENSION . 'dv_simple_html_dom/system/library/dv_simple_html_dom.php';
            }
            $html_dom = new \Opencart\System\Library\Extension\DvSimpleHtmlDom\DvSimpleHtmlDom();
            $html_dom->load($page_data['header'], $lowercase = true, $stripRN = false, $defaultBRText = DEFAULT_BR_TEXT);

            if (!empty($data['scripts'])) {
                foreach ($data['scripts'] as $script) {
                    if (!$html_dom->find('head', 0)->find('script[src="'.$script.'"]')) {
                        $html_dom->find('head', 0)->innertext='<script src="'.$script.'" type="text/javascript"></script>';
                    }
                }
            }

            if (!empty($data['styles'])) {
                foreach ($data['styles'] as $style) {
                    if (!$html_dom->find('head', 0)->find('link[href="'.$style.'"]')) {
                        $html_dom->find('head', 0)->innertext='<link href="'.$style.'" rel="stylesheet" type="text/css"></script>';
                    }
                }
            }
            $page_data['header'] = (string)$html_dom;
        } else {
            if (!empty($data['scripts'])) {
                foreach ($data['scripts'] as $script) {
                    $this->document->addScript($script);
                }
            }

            if (!empty($data['styles'])) {
                foreach ($data['styles'] as $style) {
                    $this->document->addStyle($style);
                }
            }
        }

        return $data['content'];
    }

    /**
     * Get list of all blocks
     * @return array
     */
    public function getBlocks()
    {
        $dir = DIR_EXTENSION.'/visual_designer/system/config/visual_designer';
        $files = scandir($dir);
        $result = array();
        foreach ($files as $file) {
            if (strlen($file) > 1 && strpos($file, '.php')) {
                $result[] = substr($file, 0, -4);
            }
        }
		if (is_file(DIR_EXTENSION . '/visual_designer_module/install.json')) {
			$dir = DIR_EXTENSION.'/visual_designer_module/system/config/visual_designer';
			$files = scandir($dir);

			foreach ($files as $file) {
				if (strlen($file) > 1 && strpos($file, '.php')) {
					$result[] = substr($file, 0, -4);
				}
			}
		}
		if (is_file(DIR_EXTENSION . '/visual_designer_landing/install.json')) {
			$dir = DIR_EXTENSION.'/visual_designer_landing/system/config/visual_designer';
			$files = scandir($dir);

			foreach ($files as $file) {
				if (strlen($file) > 1 && strpos($file, '.php')) {
					$result[] = substr($file, 0, -4);
				}
			}
		}
        return $result;
    }

    public function validateEdit($config_name, $edit = true)
    {
        $this->error = array();



        $setting = $this->model_setting_setting->getSetting('visual_designer');

        $this->user = new \Opencart\System\Library\Cart\User($this->registry);

        if (!$this->user->isLogged()) {
            $this->error['warning'] = $this->language->get('error_permission');
        } else {
            if (!empty($setting['visual_designer_setting']['limit_access_user'])) {
                if (!empty($setting['visual_designer_setting']['access_user']) && !in_array($this->user->getId(), $setting['d_visual_designer_setting']['access_user'])) {
                    $this->error['warning'] = $this->language->get('error_permission');
                } elseif (empty($setting['visual_designer_setting']['access_user'])) {
                    $this->error['warning'] = $this->language->get('error_permission');
                }
            }
            if (!empty($setting['visual_designer_setting']['limit_access_user_group'])) {
                if (!empty($setting['visual_designer_setting']['access_user_group']) && !in_array($this->user->getGroupId(), $setting['d_visual_designer_setting']['access_user_group'])) {
                    $this->error['warning'] = $this->language->get('error_permission');
                } elseif (empty($setting['visual_designer_setting']['access_user_group'])) {
                    $this->error['warning'] = $this->language->get('error_permission');
                }
            }
        }

        $routes = array(
            'extension/visual_designer/visual_designer/designer|getTemplate',
            'extension/visual_designer/visual_designer/designer|getModule',
            'extension/visual_designer/visual_designer/designer|getContent',
            'extension/visual_designer/visual_designer/designer|getChildBlock'
            );

        if (isset($this->request->post['route'])) {
            $route = $this->request->post['route'];
        } elseif (isset($this->request->get['route'])) {
            $route = $this->request->get['route'];
        } else {
            $route = '';
        }

        if (!in_array($route, $routes)) {
            if ($edit&&(!isset($this->request->get['edit']) && !isset($this->request->post['edit']))) {
                $this->error['warning'] = $this->language->get('error_permission');
            }
            $route_info = $this->getRoute($config_name);
            if (empty($route_info)) {
                $this->error['route'] = $this->language->get('error_route');
            }

            if (!empty($route_info)&&$route_info['frontend_route'] != $route) {
                $this->error['route'] = $this->language->get('error_frontend_route');
            }
        }

        if (!$setting['visual_designer_status']) {
            $this->error['status'] = $this->language->get('error_status');
        }
        return !$this->error;
    }

    public function getSettingBlock($type)
    {
        $results = array();

        $file = DIR_EXTENSION.'visual_designer/system/config/visual_designer/'.$type.'.php';
        if (is_file($file)) {
            $_ = array();

            require($file);

            $results = array_merge($results, $_);
        } else if (is_file(DIR_EXTENSION.'visual_designer_module/system/config/visual_designer/'.$type.'.php')) {
			$file = DIR_EXTENSION.'visual_designer_module/system/config/visual_designer/'.$type.'.php';

			$_ = array();

            require($file);

            $results = array_merge($results, $_);
		}  else if (is_file(DIR_EXTENSION.'visual_designer_landing/system/config/visual_designer/'.$type.'.php')) {
			$file = DIR_EXTENSION.'visual_designer_landing/system/config/visual_designer/'.$type.'.php';

			$_ = array();

            require($file);

            $results = array_merge($results, $_);
		}

        return $results;
    }

    public function getRouteByBackendRoute($backend_route)
    {
        $routes = $this->getRoutes();
        foreach ($routes as $config => $route) {
            if ($route['backend_route'] == $backend_route) {
                $route['config_name'] = $config;
                return $route;
            }
        }
        return array();
    }

    public function getRoutes()
    {
        $dir = DIR_EXTENSION.'visual_designer/system/config/visual_designer_route/*.php';

        $files = glob($dir);

        $route_data = array();

        foreach ($files as $file) {
            $name = basename($file, '.php');
            $route_info = $this->getRoute($name);
            $route_data[$name] = $route_info;
        }
		if (is_file(DIR_EXTENSION. 'visual_designer_module/install.json')) {
			$dir = DIR_EXTENSION.'visual_designer_module/system/config/visual_designer_route/*.php';
			$files = glob($dir);
			foreach ($files as $file) {
				$name = basename($file, '.php');
				$route_info = $this->getRoute($name);
				$route_data[$name] = $route_info;
			}
		}
		if (is_file(DIR_EXTENSION. 'visual_designer_landing/install.json')) {
			$dir = DIR_EXTENSION.'visual_designer_landing/system/config/visual_designer_route/*.php';
			$files = glob($dir);
			foreach ($files as $file) {
				$name = basename($file, '.php');
				$route_info = $this->getRoute($name);
				$route_data[$name] = $route_info;
			}
		}

        return $route_data;
    }

    public function getRoute($name)
    {
        $results = array();

        $file = DIR_EXTENSION.'visual_designer/system/config/visual_designer_route/'.$name.'.php';

        if (is_file($file)) {
            $_ = array();

            require($file);

            $results = array_merge($results, $_);
        }
		if (is_file(DIR_EXTENSION. 'visual_designer_module/install.json')) {
			$file = DIR_EXTENSION.'visual_designer_module/system/config/visual_designer_route/'.$name.'.php';
			if (is_file($file)) {
				require($file);

				$results = array_merge($results, $_);
			}
		}
		if (is_file(DIR_EXTENSION. 'visual_designer_landing/install.json')) {
			$file = DIR_EXTENSION.'visual_designer_landing/system/config/visual_designer_route/'.$name.'.php';
			if (is_file($file)) {
				require($file);

				$results = array_merge($results, $_);
			}
		}

        return $results;
    }

    public function editProduct($product_id, $data)
    {
        if (!empty($data['product_description'])) {
            foreach ($data['product_description'] as $language_id => $value) {
                $implode = array();

                if (isset($value['name'])) {
                    $implode[] = "name='".$this->db->escape($value['name'])."'";
                }

                if (isset($value['description'])) {
                    $implode[] = "description='".$this->db->escape($value['description'])."'";
                }

                if (count($implode) > 0) {
                    $this->db->query("UPDATE " . DB_PREFIX . "product_description SET ".implode(',', $implode)."
                        WHERE product_id = '".$product_id."' AND language_id='".$language_id."'");
                }
            }
        }
    }
    public function editCaregory($category_id, $data)
    {
        if (!empty($data['category_description'])) {
            foreach ($data['category_description'] as $language_id => $value) {
                $implode = array();

                if (isset($value['name'])) {
                    $implode[] = "name='".$this->db->escape($value['name'])."'";
                }

                if (isset($value['description'])) {
                    $implode[] = "description='".$this->db->escape($value['description'])."'";
                }

                if (count($implode) > 0) {
                    $this->db->query("UPDATE " . DB_PREFIX . "category_description SET ".implode(',', $implode)."
                        WHERE category_id = '".$category_id."' AND language_id='".$language_id."'");
                }
            }
        }
    }

    public function editInformation($information_id, $data)
    {
        if (!empty($data['information_description'])) {
            foreach ($data['information_description'] as $language_id => $value) {
                $implode = array();

                if (isset($value['name'])) {
                    $implode[] = "name='".$this->db->escape($value['name'])."'";
                }

                if (isset($value['description'])) {
                    $implode[] = "description='".$this->db->escape($value['description'])."'";
                }

                if (count($implode) > 0) {
                    $this->db->query("UPDATE " . DB_PREFIX . "information_description SET ".implode(',', $implode)."
                        WHERE information_id = '".$information_id."' AND language_id='".$language_id."'");
                }
            }
        }
    }

    public function prepareUserSetting($setting)
    {
        $data = array();

        if (!empty($setting['design_background_image'])) {
            $image = $setting['design_background_image'];

            if (is_file(DIR_IMAGE.$image)) {
                list($width, $height) = getimagesize(DIR_IMAGE . $image);
                $data['design_background_image'] = $this->model_tool_image->resize($image, $width, $height);
            }
        }
        return $data;
    }

    public function getSetting($setting, $type)
    {
        if (!empty($this->session->data['vd_test_setting'])) {
            if(is_file(DIR_APPLICATION.'controller/'.$this->codename.'_module/'.$type.'.php')) {
                rename(DIR_APPLICATION.'controller/'.$this->codename.'_module/'.$type.'.php', DIR_APPLICATION.'controller/extension/'.$this->codename.'_module/'.$type.'.php_');
            }

            unset($this->session->data['vd_test_setting']);
            return $setting;
        }

        $this->session->data['vd_test_setting'] = true;
		$this->config->addPath(DIR_EXTENSION . 'visual_designer/system/config/');
        $this->config->load('visual_designer');

        $setting_main = $this->config->get('visual_designer_default_block_setting');

        $setting_default = $this->getSettingBlock($type);

        $result = $setting_main;

        if (!empty($setting_default['setting'])) {
            foreach ($setting_default['setting'] as $key => $value) {
                $result[$key] = $value;
            }
        }

        if (!empty($setting)) {
            foreach ($setting as $key => $value) {
                if (!is_array($value) && !empty($setting_default['types'][$key])) {
                    if ($setting_default['types'][$key] == 'boolean') {
                        $result[$key] = $value? true : false;
                    } elseif ($setting_default['types'][$key] == 'number') {
                        $result[$key] = (int)$value;
                    } elseif ($setting_default['types'][$key] == 'string') {
                        $result[$key] = (string)$value;
                    } else {
                        $result[$key] = $value;
                    }
                } else {
                    $result[$key] = $value;
                }
            }
        }

        $userSetting = $this->vd_block->load($type, 'index', $result);

        if (!$userSetting || !is_array($userSetting)) {
            $userSetting = array();
        }

        $globalUserSetting = $this->prepareUserSetting($result);

        $userSetting = array_merge($globalUserSetting, $userSetting);

        unset($this->session->data['vd_test_setting']);

        return array('global'=>$result, 'user' => $userSetting);
    }

    public function getRiotTags($compress = true)
    {
        $result = array();

        if ($compress) {
            if (!is_dir(DIR_EXTENSION."visual_designer/catalog/view/template/visual_designer/compress")) {
                $this->compressRiotTag();
            }

            $files = glob(DIR_EXTENSION."visual_designer/catalog/view/template/visual_designer/compress/*.tag", GLOB_BRACE);

            foreach ($files as $file) {
                $result[] = HTTP_SERVER . 'extension/visual_designer/catalog/view/template/visual_designer/compress/'.basename($file);
            }
			if (is_file(DIR_EXTENSION . 'visual_designer_module/install.json')) {
				$files = glob(DIR_EXTENSION."visual_designer_module/catalog/view/template/visual_designer/compress/*.tag", GLOB_BRACE);

				foreach ($files as $file) {
					$result[] = HTTP_SERVER . 'extension/visual_designer_module/catalog/view/template/visual_designer/compress/'.basename($file);
				}
			}
			if (is_file(DIR_EXTENSION . 'visual_designer_landing/install.json')) {
				$files = glob(DIR_EXTENSION."visual_designer_landing/catalog/view/template/visual_designer/compress/*.tag", GLOB_BRACE);

				foreach ($files as $file) {
					$result[] = HTTP_SERVER . 'extension/visual_designer_landing/catalog/view/template/visual_designer/compress/'.basename($file);
				}
			}
        }

        if (!$compress || empty($result)) {
            $files = glob(DIR_EXTENSION."visual_designer/catalog/view/template/visual_designer/{components,elements,layouts,content_blocks}/*.tag", GLOB_BRACE);
            foreach ($files as $file) {
                $result[] = HTTP_SERVER . 'extension/visual_designer/catalog/view/template/visual_designer/'.basename(dirname($file)).'/'.basename($file);
            }
			if (is_file(DIR_EXTENSION . 'visual_designer_module/install.json')) {
				$files = glob(DIR_EXTENSION."visual_designer_module/catalog/view/template/visual_designer/{components,elements,layouts,content_blocks}/*.tag", GLOB_BRACE);
				foreach ($files as $file) {
					$result[] = HTTP_SERVER . 'extension/visual_designer_module/catalog/view/template/visual_designer/'.basename(dirname($file)).'/'.basename($file);
				}
			}
			if (is_file(DIR_EXTENSION . 'visual_designer_landing/install.json')) {
				$files = glob(DIR_EXTENSION."visual_designer_landing/catalog/view/template/visual_designer/{components,elements,layouts,content_blocks}/*.tag", GLOB_BRACE);
				foreach ($files as $file) {
					$result[] = HTTP_SERVER . 'extension/visual_designer_landing/catalog/view/template/visual_designer/'.basename(dirname($file)).'/'.basename($file);
				}
			}
        }

        return $result;
    }

    public function compressRiotTag()
    {
        $this->compressRiotTagByFolder(DIR_EXTENSION."visual_designer/catalog/view/template/visual_designer/");
		if (is_file(DIR_EXTENSION . 'visual_designer_module/install.json')) {
			$this->compressRiotTagByFolder(DIR_EXTENSION."visual_designer_module/catalog/view/template/visual_designer/");
		}
		if (is_file(DIR_EXTENSION . 'visual_designer_landing/install.json')) {
			$this->compressRiotTagByFolder(DIR_EXTENSION."visual_designer_landing/catalog/view/template/visual_designer/");
		}
    }

    protected function compressRiotTagByFolder($folder)
    {
        if (is_dir($folder."compress")) {
            array_map('unlink', glob($folder."compress/*"));
        } else {
            mkdir($folder."compress");
        }

        $files = glob($folder . 'components/*.tag', GLOB_BRACE);

        foreach ($files as $file) {
            file_put_contents($folder."compress/component.tag", file_get_contents($file).PHP_EOL, FILE_APPEND);
        }
        $files = glob($folder . 'elements/*.tag', GLOB_BRACE);

        foreach ($files as $file) {
            if (is_file($folder . 'elements/'.basename($file))) {
                $file = $folder . 'elements/'.basename($file);
            }
            file_put_contents($folder."compress/elements.tag", file_get_contents($file).PHP_EOL, FILE_APPEND);
        }
        $files = glob($folder . 'layouts/*.tag', GLOB_BRACE);
        foreach ($files as $file) {
            file_put_contents($folder."compress/layouts.tag", file_get_contents($file).PHP_EOL, FILE_APPEND);
        }
        $files = glob($folder . 'content_blocks/*.tag', GLOB_BRACE);
        foreach ($files as $file) {
            if (is_file($folder . 'content_blocks/'.basename($file))) {
                $file = $folder . 'content_blocks/'.basename($file);
            }
            file_put_contents($folder."compress/content_blocks.tag", file_get_contents($file).PHP_EOL, FILE_APPEND);
        }
    }
}
