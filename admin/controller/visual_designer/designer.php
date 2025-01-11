<?php
namespace Opencart\Admin\Controller\Extension\VisualDesigner\VisualDesigner;

class Designer extends \Opencart\System\Engine\Controller
{
    public $codename = 'visual_designer';
    public $route = 'extension/visual_designer/visual_designer/designer';
    public $extension = '';

    private $d_shopunity = '';

    private $scripts = array();
    private $styles = array();

    private $error = array();

    private $store_url = '';

    private $catalog_url = '';

    private $store_id = '';


    public function __construct($registry)
    {
        parent::__construct($registry);
        $this->load->language($this->route);
        $this->load->language('extension/visual_designer/module/visual_designer');
        $this->load->model($this->route);
        $this->load->model('extension/visual_designer/module/visual_designer');

		$this->extension = json_decode(file_get_contents(DIR_EXTENSION.'visual_designer/install.json'), true);
        $this->store_id = (isset($this->request->get['store_id'])) ? $this->request->get['store_id'] : 0;

        $this->store_url = HTTP_SERVER;
        $this->catalog_url = HTTP_CATALOG;

		if (is_file(DIR_EXTENSION . 'visual_designer_module/install.json')) {
			// Template directory
			$this->template->addPath('extension/visual_designer_module', DIR_EXTENSION . 'visual_designer_module/admin/view/template/');
			// Language directory
			$this->language->addPath('extension/visual_designer_module', DIR_EXTENSION . 'visual_designer_module/admin/language/');
		}
		if (is_file(DIR_EXTENSION . 'visual_designer_landing/install.json')) {
			// Template directory
			$this->template->addPath('extension/visual_designer_landing', DIR_EXTENSION . 'visual_designer_landing/admin/view/template/');
			// Language directory
			$this->language->addPath('extension/visual_designer_landing', DIR_EXTENSION . 'visual_designer_landing/admin/language/');
		}
    }

    public function index($setting)
    {
        if ($this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->validateEdit($setting['config'])) {
            $this->styles[] = HTTP_CATALOG . 'extension/visual_designer/admin/view/stylesheet/d_visual_designer/d_visual_designer.css?'.rand();

            $this->styles[] = HTTP_CATALOG . 'extension/visual_designer/admin/view/javascript/d_visual_designer/dist/vd-libraries.min.css';
            $this->scripts[] = HTTP_CATALOG . 'extension/dv_riot/admin/view/javascript/dv_riot/riotcompiler.min.js';
            $this->scripts[] = HTTP_CATALOG . 'extension/visual_designer/admin/view/javascript/d_visual_designer/main.js';
            $this->scripts[] = HTTP_CATALOG . 'extension/visual_designer/admin/view/javascript/d_visual_designer/model/designer.js';
            $this->scripts[] = HTTP_CATALOG . 'extension/visual_designer/admin/view/javascript/d_visual_designer/model/content.js';
            $this->scripts[] = HTTP_CATALOG . 'extension/visual_designer/admin/view/javascript/d_visual_designer/model/block.js';
            $this->scripts[] = HTTP_CATALOG . 'extension/visual_designer/admin/view/javascript/d_visual_designer/model/history.js';
            $this->scripts[] = HTTP_CATALOG . 'extension/visual_designer/admin/view/javascript/d_visual_designer/model/template.js';
            $this->scripts[] = HTTP_CATALOG . 'extension/visual_designer/admin/view/javascript/d_visual_designer/model/sortable.js';
            $this->scripts[] = 'view/javascript/ckeditor/ckeditor.js';
			$this->scripts[] = 'view/javascript/ckeditor/adapters/jquery.js';

            $this->scripts[] = HTTP_CATALOG . 'extension/visual_designer/admin/view/javascript/d_visual_designer/dist/vd-libraries.min.js';

            $this->load->model('setting/setting');

            $setting_module = $this->model_setting_setting->getSetting($this->codename);

            if (!empty($setting_module[$this->codename.'_setting'])) {
                $setting_module = $setting_module[$this->codename.'_setting'];
            } else {
                $this->load->config($this->codename);
                $setting_module = $this->config->get($this->codename.'_setting');
            }

            $data['riot_tags'] = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->getRiotTags($setting_module['compress_files']);

            $data['state']['config'] = array();
            $data['state']['blocks'] = array();
            $data['state']['drag'] = array();
            $data['state']['content'] = array();
            $data['state']['history'] = array();

            $data['state']['config']['notify'] = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->checkCompleteVersion();

            $route_info = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->getRoute($setting['config']);

            $data['state']['config']['independent'] = array();
            $data['state']['config']['mode'] = array();
            $data['state']['config']['filemanager_url'] = html_entity_decode($this->url->link($this->route.'|getFileManager', 'user_token=' . $this->session->data['user_token']));
            $data['state']['config']['new_image_url'] = html_entity_decode($this->url->link($this->route.'|getImage', 'user_token=' . $this->session->data['user_token']));
            $data['state']['config']['mode'] = array();
            $data['state']['config']['route'] = $setting['config'];
            $data['state']['config']['route_info'] = $route_info;
            $data['state']['config']['id'] = $setting['id'];
            $data['state']['config']['blocks'] = $this->prepareBlocksConfig();
            $data['state']['config']['frontend'] = html_entity_decode($this->url->link($this->route.'|frontend', 'user_token=' . $this->session->data['user_token'] . '&config='.$setting['config'].'&id='.$setting['id']));

            $data['state']['config']['url_token'] = 'user_token=' . $this->session->data['user_token'];

            $data['state']['templates'] = $this->prepareTemplate();

            $data['local'] = $this->prepareLocal();
            $data['options'] = $this->prepareOptions();
            $this->prepareScripts();
            $this->prepareStyles();

            $data['base'] = $this->store_url;

            if ($setting['output']) {
                $output = $this->parseHeader($setting['output']);

                if($output) {
                    $setting['output'] = $output;
                }
            } else {
                $this->parseHeader();
            }

            return $this->load->view($this->route, $data);
        } else {
            return '';
        }
    }

    public function field($field_data) {
        $data['text_label'] = $this->language->get('text_field_label');

        $data['name'] = $field_data['field'];
        $data['content'] = $field_data['content'];

        return $this->load->view('extension/visual_designer/'.$this->codename.'/field', $data);
    }

    protected function parseHeader($header = false)
    {
        if ($header) {
            if (
                !class_exists('\\Opencart\\System\\Library\\Extension\\DvSimpleHtmlDom\\DvSimpleHtmlDom') && 
                is_file(DIR_EXTENSION . 'dv_simple_html_dom/system/library/dv_simple_html_dom.php')
            ) {
                require_once DIR_EXTENSION . 'dv_simple_html_dom/system/library/dv_simple_html_dom.php';
            }
            $html_dom = new \Opencart\System\Library\Extension\DvSimpleHtmlDom\DvSimpleHtmlDom();
            $html_dom->load($header, $lowercase = true, $stripRN = false, $defaultBRText = DEFAULT_BR_TEXT);

            foreach ($this->scripts as $script) {
                if (!$html_dom->find('head', 0)->find('script[src="' . $script . '"]')) {
                    $html_dom->find('head > script', -1)->outertext .= '<script src="' . $script . '" type="text/javascript"></script>';
                }
            }

            foreach ($this->styles as $style) {
                if (!$html_dom->find('head', 0)->find('link[href="' . $style . '"]')) {
                    $html_dom->find('head > link', -1)->outertext .= '<link href="' . $style . '" rel="stylesheet" type="text/css"></script>';
                }
            }
            return (string)$html_dom;
        } else {
            foreach ($this->scripts as $script) {
                $this->document->addScript($script);
            }

            foreach ($this->styles as $style) {
                $this->document->addStyle($style);
            }
        }

        return false;
    }

    public function loadSetting()
    {
        $json = array();

        if (!empty($this->request->post['setting'])) {
            $setting = json_decode(html_entity_decode($this->request->post['setting'], ENT_QUOTES, 'UTF-8'), true);
        }


        if (isset($setting['route'])) {
            $route = $setting['route'];
        }

        if (isset($setting['field_name'])) {
            $field_name = $setting['field_name'];
        }

        if (isset($setting['content'])) {
            $content = $setting['content'];
        }

        if (isset($setting['id'])) {
            $id = $setting['id'];
        }

        if (isset($route) && isset($field_name) && isset($content) && isset($id)) {
            if ($id != '') {
                $result = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->getContent($route, $id, $field_name);
                if (!empty($result) && !empty($result['content'])) {
                    $content = $result['content'];
                }
            }

            $shortcode = false;
            $block_setting = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->parseContent($content, array(&$shortcode));

            $json['designer_id'] = substr(md5(rand()), 0, 7);
            $json['content'] = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->parseSetting($block_setting);
            if ($shortcode) {
                $json['text'] = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->getText($block_setting);
            }

            $json['blocks'] = $block_setting;

            $json['success'] = 'success';
        } else {
            $json['error'] = 'error';
        }

        $this->response->addHeader("Content-Type: application/json");
        $this->response->setOutput(json_encode($json, JSON_FORCE_OBJECT));
    }

    protected function prepareScripts()
    {
        $blocks = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->getBlocks();

        foreach ($blocks as $block) {

			if (is_file(DIR_EXTENSION . 'visual_designer/admin/controller/visual_designer_module/'.$block.'.php')) {
				$output = $this->load->controller('extension/visual_designer/visual_designer_module/'.$block.'|scripts');
			} else if (is_file(DIR_EXTENSION . 'visual_designer_module/admin/controller/visual_designer_module/'.$block.'.php')) {
				// if VD Module has uninstalled
				if (!class_exists('Opencart\\Admin\\Controller\\Extension\\VisualDesignerModule\\VisualDesignerModule\\' . str_replace('_', '', ucwords($block, '_')))) {
					require DIR_EXTENSION . 'visual_designer_module/admin/controller/visual_designer_module/'.$block.'.php';
				}
				$output = $this->load->controller('extension/visual_designer_module/visual_designer_module/'.$block.'|scripts');
			} else if (is_file(DIR_EXTENSION . 'visual_designer_landing/admin/controller/visual_designer_module/'.$block.'.php')) {
				// if VD Landing has uninstalled
				if (!class_exists('Opencart\\Admin\\Controller\\Extension\\VisualDesignerLanding\\VisualDesignerModule\\' . str_replace('_', '', ucwords($block, '_')))) {
					require DIR_EXTENSION . 'visual_designer_landing/admin/controller/visual_designer_module/'.$block.'.php';
				}
				$output = $this->load->controller('extension/visual_designer_landing/visual_designer_module/'.$block.'|scripts');
			}
            if (is_array($output)) {
                $this->scripts = array_merge($this->scripts, $output);
            }
        }
		if (is_file(DIR_EXTENSION . 'visual_designer_module/install.json')) {
			foreach ($blocks as $block) {
				$output = $this->load->controller('extension/visual_designer_module/visual_designer_module/'.$block.'|scripts');
				if (is_array($output)) {
					$this->scripts = array_merge($this->scripts, $output);
				}
			}
		}
		if (is_file(DIR_EXTENSION . 'visual_designer_pro/install.json')) {
			foreach ($blocks as $block) {
				$output = $this->load->controller('extension/visual_designer_pro/visual_designer_module/'.$block.'|scripts');
				if (is_array($output)) {
					$this->scripts = array_merge($this->scripts, $output);
				}
			}
		}
    }
    protected function prepareStyles()
    {
        $blocks = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->getBlocks();

        foreach ($blocks as $block) {

			if (is_file(DIR_EXTENSION . 'visual_designer/admin/controller/visual_designer_module/'.$block.'.php')) {
				$output = $this->load->controller('extension/visual_designer/visual_designer_module/'.$block.'|styles');
			} else if (is_file(DIR_EXTENSION . 'visual_designer_module/admin/controller/visual_designer_module/'.$block.'.php')) {
				// if VD Module has uninstalled
				if (!class_exists('Opencart\\Admin\\Controller\\Extension\\VisualDesignerModule\\VisualDesignerModule\\' . str_replace('_', '', ucwords($block, '_')))) {
					require DIR_EXTENSION . 'visual_designer_module/admin/controller/visual_designer_module/'.$block.'.php';
				}
				$output = $this->load->controller('extension/visual_designer_module/visual_designer_module/'.$block.'|styles');
			} else if (is_file(DIR_EXTENSION . 'visual_designer_landing/admin/controller/visual_designer_module/'.$block.'.php')) {
				// if VD Landing has uninstalled
				if (!class_exists('Opencart\\Admin\\Controller\\Extension\\VisualDesignerLanding\\VisualDesignerModule\\' . str_replace('_', '', ucwords($block, '_')))) {
					require DIR_EXTENSION . 'visual_designer_landing/admin/controller/visual_designer_module/'.$block.'.php';
				}
				$output = $this->load->controller('extension/visual_designer_landing/visual_designer_module/'.$block.'|styles');
			}
            if (is_array($output)) {
                $this->styles = array_merge($this->styles, $output);
            }
        }
		if (is_file(DIR_EXTENSION . 'visual_designer_module/install.json')) {
			foreach ($blocks as $block) {
				$output = $this->load->controller('extension/visual_designer_module/visual_designer_module/'.$block.'|styles');
				if (is_array($output)) {
					$this->styles = array_merge($this->styles, $output);
				}
			}
		}
		if (is_file(DIR_EXTENSION . 'visual_designer_pro/install.json')) {
			foreach ($blocks as $block) {
				$output = $this->load->controller('extension/visual_designer_pro/visual_designer_module/'.$block.'|styles');
				if (is_array($output)) {
					$this->styles = array_merge($this->styles, $output);
				}
			}
		}
    }

    public function prepareBlocksConfig()
    {
        $blocks = array();

        $this->load->model('tool/image');

        $results = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->getBlocks();

        foreach ($results as $block) {
			if (is_file(DIR_EXTENSION . 'visual_designer/admin/controller/visual_designer_module/'.$block . '.php')) {
				$this->load->language('extension/visual_designer/'.$this->codename.'_module/'.$block);
			} else if (is_file(DIR_EXTENSION . 'visual_designer_module/admin/controller/visual_designer_module/'.$block . '.php')) {
				$this->load->language('extension/visual_designer_module/'.$this->codename.'_module/'.$block);
			} else if (is_file(DIR_EXTENSION . 'visual_designer_landing/admin/controller/visual_designer_module/'.$block . '.php')) {
				$this->load->language('extension/visual_designer_landing/'.$this->codename.'_module/'.$block);
			}


            $setting = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->getSettingBlock($block);

            $setting_default = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->getSetting($setting['setting'], $block);

            if (is_file(DIR_IMAGE .'catalog/d_visual_designer/'.$block.'.svg')) {
                $image = '../image/catalog/d_visual_designer/'.$block.'.svg';
            } else {
                $image = $this->model_tool_image->resize('no_image.png', 32, 32);
            }

            if ($setting['display']) {
                $blocks[$block] = array(
                    'title' => $this->language->get('text_title'),
                    'description' => $this->language->get('text_description'),
                    'image' => $image,
                    'type'    => $block,
                    'setting_default' => $setting_default,
                    'category' => ucfirst($setting['category']),
                    'sort_order' => isset($setting['sort_order'])? $setting['sort_order'] : 0,
                    'setting' => $setting
                );
            }
        }
        usort($blocks, 'Opencart\Admin\Controller\Extension\VisualDesigner\VisualDesigner\Designer::sort_block');

        return $blocks;
    }

    public function prepareTemplate()
    {
        $templates = array();

        $this->load->model('tool/image');
        $this->load->model('extension/visual_designer/'.$this->codename.'/template');

        $results = $this->{'model_extension_visual_designer_'.$this->codename.'_template'}->getTemplates();

        foreach ($results as $template) {
            if ($template['image'] && is_file(DIR_IMAGE.$template['image'])) {
                $image = $this->model_tool_image->resize($template['image'], 160, 205);
            } else {
                $image = $this->model_tool_image->resize('no_image.png', 160, 205);
            }
            $templates[] = array(
                'template_id' => $template['template_id'],
                'config' => $template['config'],
                'image' => $image,
                'category' => ucfirst($template['category']),
                'name' => html_entity_decode($template['name'], ENT_QUOTES, "UTF-8")
            );
        }

        return $templates;
    }


    protected function prepareLocal($front = false)
    {
        $local = array();

        if($front) {
            $local['designer']['button_add_block'] = $this->language->get('button_add_block');
            $local['designer']['button_add_template'] = $this->language->get('button_add_template');
            $local['designer']['button_save_template'] = $this->language->get('button_save_template');
            $local['designer']['button_mobile'] = $this->language->get('button_mobile');
            $local['designer']['button_tablet'] = $this->language->get('button_tablet');
            $local['designer']['button_desktop'] = $this->language->get('button_desktop');
            $local['designer']['button_reload'] = $this->language->get('button_reload');

            $local['designer']['button_backend_editor'] = $this->language->get('button_backend_editor');
            $local['designer']['button_publish'] = $this->language->get('button_publish');
            $local['designer']['button_cancel'] = $this->language->get('button_cancel');

            $local['designer']['text_save_template'] = $this->language->get('text_save_template');
            $local['designer']['text_success_update'] = $this->language->get('text_success_update');
            $local['designer']['error_permission'] = $this->language->get('error_permission');
            $local['designer']['text_success_template_save'] = $this->language->get('text_success_template_save');
            $local['designer']['text_success_clone_block'] = $this->language->get('text_success_clone_block');
            $local['designer']['text_success_remove_block'] = $this->language->get('text_success_remove_block');
        }

        $local['designer']['button_add'] = $this->language->get('button_add');
        $local['designer']['button_close'] = $this->language->get('button_close');
        $local['designer']['button_save'] = $this->language->get('button_save');
        $local['designer']['button_saved'] = $this->language->get('button_saved');
        //text
        $local['designer']['text_add_block'] = $this->language->get('text_add_block');
        $local['designer']['text_edit_block'] = $this->language->get('text_edit_block');
        $local['designer']['text_add_template'] = $this->language->get('text_add_template');
        $local['designer']['text_codeview'] = $this->language->get('text_codeview');
        $local['designer']['text_classic_mode'] = $this->language->get('text_classic_mode');
        $local['designer']['text_backend_editor'] = $this->language->get('text_backend_editor');
        $local['designer']['text_frontend_editor'] = $this->language->get('text_frontend_editor');
        $local['designer']['text_designer'] = $this->language->get('text_designer');
        $local['designer']['text_welcome_header'] = $this->language->get('text_welcome_header');
        $local['designer']['text_add_block'] = $this->language->get('text_add_block');
        $local['designer']['text_add_text_block'] = $this->language->get('text_add_text_block');
        $local['designer']['text_add_template'] = $this->language->get('text_add_template');
        $local['designer']['text_save_template'] = $this->language->get('text_save_template');
        $local['designer']['text_search'] = $this->language->get('text_search');
        $local['designer']['text_layout'] = $this->language->get('text_layout');
        $local['designer']['text_set_custom'] = $this->language->get('text_set_custom');
        $local['designer']['text_add_child_block'] = $this->language->get('text_add_child_block');
        $local['designer']['text_add'] = $this->language->get('text_add');
        $local['designer']['text_file_manager'] = $this->language->get('text_file_manager');

        $local['designer']['entry_border_color'] = $this->language->get('entry_border_color');
        $local['designer']['entry_border_style'] = $this->language->get('entry_border_style');
        $local['designer']['entry_border_radius'] = $this->language->get('entry_border_radius');
        $local['designer']['entry_animate'] = $this->language->get('entry_animate');
        $local['designer']['entry_show_on'] = $this->language->get('entry_show_on');
        $local['designer']['entry_background'] = $this->language->get('entry_background');
        $local['designer']['entry_id'] = $this->language->get('entry_id');
        $local['designer']['entry_additional_css_class'] = $this->language->get('entry_additional_css_class');
        $local['designer']['entry_additional_css_before'] = $this->language->get('entry_additional_css_before');
        $local['designer']['entry_additional_css_content'] = $this->language->get('entry_additional_css_content');
        $local['designer']['entry_additional_css_after'] = $this->language->get('entry_additional_css_after');
        $local['designer']['entry_margin'] = $this->language->get('entry_margin');
        $local['designer']['entry_padding'] = $this->language->get('entry_padding');
        $local['designer']['entry_border'] = $this->language->get('entry_border');
        $local['designer']['entry_name'] = $this->language->get('entry_name');
        $local['designer']['entry_category'] = $this->language->get('entry_category');
        $local['designer']['entry_image'] = $this->language->get('entry_image');
        $local['designer']['entry_image_style'] = $this->language->get('entry_image_style');
        $local['designer']['entry_image_position'] = $this->language->get('entry_image_position');
        $local['designer']['entry_size'] = $this->language->get('entry_size');
        $local['designer']['entry_image_template'] = $this->language->get('entry_image_template');
        $local['designer']['entry_sort_order'] = $this->language->get('entry_sort_order');

        $local['designer']['tab_general'] = $this->language->get('tab_general');
        $local['designer']['tab_design'] = $this->language->get('tab_design');
        $local['designer']['tab_css'] = $this->language->get('tab_css');
        $local['designer']['tab_save_block'] = $this->language->get('tab_save_block');
        $local['designer']['tab_templates'] = $this->language->get('tab_templates');
        $local['designer']['tab_all_blocks'] = $this->language->get('tab_all_blocks');
        $local['designer']['tab_content_blocks'] = $this->language->get('tab_content_blocks');
        $local['designer']['tab_social_blocks'] = $this->language->get('tab_social_blocks');
        $local['designer']['tab_structure_blocks'] = $this->language->get('tab_structure_blocks');

        $local['designer']['text_top'] = $this->language->get('text_top');
        $local['designer']['text_right'] = $this->language->get('text_right');
        $local['designer']['text_bottom'] = $this->language->get('text_bottom');
        $local['designer']['text_left'] = $this->language->get('text_left');

        $local['designer']['text_yes'] = $this->language->get('text_yes');
        $local['designer']['text_no'] = $this->language->get('text_no');
        $local['designer']['text_enabled'] = $this->language->get('text_enabled');

        $local['designer']['text_phone'] = $this->language->get('text_phone');
        $local['designer']['text_tablet'] = $this->language->get('text_tablet');
        $local['designer']['text_desktop'] = $this->language->get('text_desktop');

        $local['designer']['text_horizontal'] = $this->language->get('text_horizontal');
        $local['designer']['text_vertical'] = $this->language->get('text_vertical');

        $local['designer']['text_complete_version'] = $this->language->get('text_complete_version');
        $local['designer']['text_complete_version_template'] = $this->language->get('text_complete_version_template');

        $local['designer']['error_name'] = $this->language->get('error_name');

        //error
        $local['designer']['error_size'] = $this->language->get('error_size');

        $blocks = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->getBlocks();

        $local['blocks'] = array();

        foreach ($blocks as $block) {
			if (is_file(DIR_EXTENSION . 'visual_designer/admin/controller/visual_designer_module/'.$block.'.php')) {
				$local['blocks'][$block] = $this->load->controller('extension/visual_designer/visual_designer_module/'.$block.'|local');
			} else if (is_file(DIR_EXTENSION . 'visual_designer_module/admin/controller/visual_designer_module/'.$block.'.php')) {
				// if VD Module has uninstalled
				if (!class_exists('Opencart\\Admin\\Controller\\Extension\\VisualDesignerModule\\VisualDesignerModule\\' . str_replace('_', '', ucwords($block, '_')))) {
					require DIR_EXTENSION . 'visual_designer_module/admin/controller/visual_designer_module/'.$block.'.php';
				}
				$local['blocks'][$block] = $this->load->controller('extension/visual_designer_module/visual_designer_module/'.$block.'|local');
			} else if (is_file(DIR_EXTENSION . 'visual_designer_landing/admin/controller/visual_designer_module/'.$block.'.php')) {
				// if VD Landing has uninstalled
				if (!class_exists('Opencart\\Admin\\Controller\\Extension\\VisualDesignerLanding\\VisualDesignerModule\\' . str_replace('_', '', ucwords($block, '_')))) {
					require DIR_EXTENSION . 'visual_designer_landing/admin/controller/visual_designer_module/'.$block.'.php';
				}
				$local['blocks'][$block] = $this->load->controller('extension/visual_designer_landing/visual_designer_module/'.$block.'|local');
			}
        }

        return $local;
    }

    protected function prepareOptions()
    {
        $options = array();

        $this->load->model('tool/image');

        $options['designer']['placeholder'] = $this->model_tool_image->resize('no_image.png', 100, 100);

        $options['designer']['border_styles'] = array(
            ''       => $this->language->get('text_default'),
            'dotted' => $this->language->get('text_dotted'),
            'dashed' => $this->language->get('text_dashed'),
            'solid'  => $this->language->get('text_solid'),
            'double' => $this->language->get('text_double'),
            'groove' => $this->language->get('text_groove'),
            'ridge'  => $this->language->get('text_ridge'),
            'inset'  => $this->language->get('text_inset'),
            'outset' => $this->language->get('text_outset')
            );

        $options['designer']['image_styles'] = array(
                'cover' => $this->language->get('text_cover'),
                'contain' => $this->language->get('text_contain'),
                'no-repeat'  => $this->language->get('text_no_repeat'),
                'repeat' => $this->language->get('text_repeat'),
                'parallax' => $this->language->get('text_parallax')
                );

        $options['designer']['image_horizontal_positions'] = array(
                'left' => $this->language->get('text_position_left'),
                'center' => $this->language->get('text_position_center'),
                'right' => $this->language->get('text_position_right')
                );

        $options['designer']['image_vertical_positions'] = array(
                'top' => $this->language->get('text_position_top'),
                'center' => $this->language->get('text_position_center'),
                'bottom' => $this->language->get('text_position_bottom')
                );

        $options['designer']['animates'] = array(
                '' => $this->language->get('text_none'),
                'fadeInDown' => $this->language->get('text_fade_in_down'),
                'fadeInUp' => $this->language->get('text_fade_in_up'),
                'fadeInLeft' => $this->language->get('text_fade_in_left'),
                'fadeInRight' => $this->language->get('text_fade_in_right'),
                'fadeIn' =>  $this->language->get('text_fade_in'),
                'bounceIn' => $this->language->get('text_bounce_in'),
                'rubberBand' => $this->language->get('text_rubber_band'),
                'rollIn' => $this->language->get('text_roll_in'),
                'lightSpeedIn' => $this->language->get('text_light_speed_in'),
                'flipInX' => $this->language->get('text_flip_in_x'),
                'flipInY' => $this->language->get('text_flip_in_y'),
                'jello' => $this->language->get('text_jello'),
                'mk-floating-tossing' => $this->language->get('text_mk_floating_tossing'),
                'mk-floating-pulse' => $this->language->get('text_mk_floating_pulse'),
                'mk-floating-vertical' => $this->language->get('text_mk_floating_vertical'),
                'mk-floating-horizontal' => $this->language->get('text_mk_floating_horizontal'),
                'bounce_jump' => $this->language->get('text_bounce_jump')
                );

        $options['designer']['libraries'] = array(
            'fontawesome' => 'Font Awesome',
            'glyphicon' => 'Glyphicons',
            'ionicons' => 'Open Ionic',
            'mapicons' => 'Map Icons',
            'material' => 'Material Design Iconic Font',
            'typeicon' => 'Typeicons',
            'elusive' => 'Elusive Icons',
            'octicon' => 'Octicons',
            'weather' => 'Weather Icons'
        );

        $iconSets = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->getIconSets();

        foreach ($iconSets as $value) {
            $options['designer']['libraries'][$value] = $value;
            $this->scripts[] = HTTP_CATALOG . 'extension/visual_designer/admin/view/javascript/'.$this->codename."/iconset/".$value.'.js';
        }

        $blocks = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->getBlocks();

        $options['blocks'] = array();

        foreach ($blocks as $block) {
			if (is_file(DIR_EXTENSION . 'visual_designer/admin/controller/visual_designer_module/'.$block.'.php')) {
				$options['blocks'][$block] = $this->load->controller('extension/visual_designer/visual_designer_module/'.$block.'|options');
			} else if (is_file(DIR_EXTENSION . 'visual_designer_module/admin/controller/visual_designer_module/'.$block.'.php')) {
				// if VD Module has uninstalled
				if (!class_exists('Opencart\\Admin\\Controller\\Extension\\VisualDesignerModule\\VisualDesignerModule\\' . str_replace('_', '', ucwords($block, '_')))) {
					require DIR_EXTENSION . 'visual_designer_module/admin/controller/visual_designer_module/'.$block.'.php';
				}
				$options['blocks'][$block] = $this->load->controller('extension/visual_designer_module/visual_designer_module/'.$block.'|options');
			} else if (is_file(DIR_EXTENSION . 'visual_designer_landing/admin/controller/visual_designer_module/'.$block.'.php')) {
				// if VD Landing has uninstalled
				if (!class_exists('Opencart\\Admin\\Controller\\Extension\\VisualDesignerLanding\\VisualDesignerModule\\' . str_replace('_', '', ucwords($block, '_')))) {
					require DIR_EXTENSION . 'visual_designer_landing/admin/controller/visual_designer_module/'.$block.'.php';
				}
				$options['blocks'][$block] = $this->load->controller('extension/visual_designer_landing/visual_designer_module/'.$block.'|options');
			}
		}

        return $options;
    }

    public function updateContent()
    {
        $json = array();

        if (isset($this->request->post['content'])) {
            $content = $this->request->post['content'];
        }

        if (isset($content)) {
            $json['setting'] = $content = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->parseContent($content);
            $json['success'] = 'success';
        } else {
            $json['errorr'] = 'error';
        }

        $this->response->addHeader('Content-Type: application/json');
        $this->response->setOutput(json_encode($json, JSON_FORCE_OBJECT));
    }

    public function updateSetting()
    {
        $json = array();

        if (isset($this->request->post['setting'])) {
            $setting = json_decode(html_entity_decode($this->request->post['setting'], ENT_QUOTES, 'UTF-8'), true);
        }

        if (isset($this->request->post['type'])) {
            $type = $this->request->post['type'];
        }

        if (isset($setting) && isset($type)) {
            $json['setting'] = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->getSetting($setting['global'], $type);
            $json['success'] = 'success';
        } else {
            $json['error'] = 'error';
        }

        $this->response->addHeader("Content-Type: application/json");
        $this->response->setOutput(json_encode($json, JSON_FORCE_OBJECT));
    }

    public function frontend()
    {
        if (!empty($this->request->get['config'])) {
            $config = html_entity_decode($this->request->get['config']);
        }

        if (!empty($this->request->get['field_name'])) {
            $field_name = html_entity_decode($this->request->get['field_name']);
        } else {
            $field_name = false;
        }

        if (isset($this->request->get['id'])) {
            $id = html_entity_decode($this->request->get['id']);
        }

        if (isset($id)&& !empty($config)) {
            $data['button_add_block'] = $this->language->get('button_add_block');
            $data['button_add_template'] = $this->language->get('button_add_template');
            $data['button_save_template'] = $this->language->get('button_save_template');
            $data['button_mobile'] = $this->language->get('button_mobile');
            $data['button_tablet'] = $this->language->get('button_tablet');
            $data['button_desktop'] = $this->language->get('button_desktop');
            $data['button_reload'] = $this->language->get('button_reload');

            $data['button_backend_editor'] = $this->language->get('button_backend_editor');
            $data['button_publish'] = $this->language->get('button_publish');
            $data['button_cancel'] = $this->language->get('button_cancel');

            $data['text_save_template'] = $this->language->get('text_save_template');
            $data['text_success_update'] = $this->language->get('text_success_update');
            $data['error_permission'] = $this->language->get('error_permission');
            $data['text_success_template_save'] = $this->language->get('text_success_template_save');
            $data['text_success_clone_block'] = $this->language->get('text_success_clone_block');
            $data['text_success_remove_block'] = $this->language->get('text_success_remove_block');

            $route_info = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->getRoute($config);

            $data['state']['config'] = array();
            $data['state']['blocks'] = array();

            $param = array();

            if (!empty($route_info['frontend_param'])&!empty($id)) {
                $param[] = $route_info['frontend_param'].'='.$id;
            }

            if (!empty($route_info['frontend_full_param']) && $field_name) {
                $param[] = 'field_name=' . $field_name;
            }

            if (!empty($route_info['frontend_full_param']) && $config) {
                $param[] = 'config=' . $config;
            }

            $data['state']['config']['frontend_base_url'] = $this->catalog_url;

            $data['state']['config']['frontend_url'] = $this->catalog_url.'index.php?route='.$route_info['frontend_route'].'&'.implode('&', $param);

            if (!empty($route_info['backend_param'])&!empty($id)) {
                $param = $route_info['backend_param'].'='.$id;
            } else {
                $param = '';
            }

            $data['state']['config']['backend_url'] = html_entity_decode($this->url->link($route_info['backend_route'], 'user_token=' . $this->session->data['user_token']. '&' . $param));

            $this->load->model('setting/setting');

            $setting_module = $this->model_setting_setting->getSetting($this->codename);

            if (!empty($setting_module[$this->codename.'_setting'])) {
                $setting_module = $setting_module[$this->codename.'_setting'];
            } else {
                $this->load->config($this->codename);
                $setting_module = $this->config->get($this->codename.'_setting');
            }

            $data['riot_tags'] = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->getRiotTags($setting_module['compress_files']);

            $data['state']['config']['notify'] = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->checkCompleteVersion();

            $data['state']['config']['update_settings_url'] = html_entity_decode($this->url->link($this->route.'|updateBlocks', 'user_token=' . $this->session->data['user_token']));
            $data['state']['config']['filemanager_url'] = html_entity_decode($this->url->link($this->route.'|getFileManager', 'user_token=' . $this->session->data['user_token']));
            $data['state']['config']['new_image_url'] = html_entity_decode($this->url->link($this->route.'|getImage', 'user_token=' . $this->session->data['user_token']));
            $data['state']['config']['blocks'] = $this->prepareBlocksConfig();

            $data['state']['history'] = array();

            $data['state']['config']['url_token'] = 'user_token=' . $this->session->data['user_token'];

            $data['state']['templates'] = $this->prepareTemplate();

            $this->scripts[] = HTTP_CATALOG . 'extension/visual_designer/admin/view/javascript/flatpickr/moment.min.js';

            $this->styles[] = HTTP_CATALOG . 'extension/visual_designer/admin/view/javascript/flatpickr/flatpickr.min.css';

            $this->scripts[] = HTTP_CATALOG . 'extension/visual_designer/admin/view/javascript/flatpickr/flatpickr.min.js';
			$this->scripts[] = HTTP_CATALOG . 'extension/visual_designer/admin/view/javascript/flatpickr/locales.min.js';
            
            $data['local'] = $this->prepareLocal(true);
            $data['options'] = $this->prepareOptions();

            $data['direction'] = $this->language->get('direction');
            $data['lang'] = $this->language->get('code');
            $data['base'] = $this->store_url;

            $data['text_file_manager'] = $this->language->get('text_file_manager');
            $data['text_frontend_title'] = $this->language->get('text_frontend_title');

            $this->parseHeader();

            $data['scripts'] = $this->document->getScripts();
            $data['styles'] = $this->document->getStyles();

            $this->response->setOutput($this->load->view('extension/visual_designer/'.$this->codename.'/frontend_editor', $data));
        }
    }

    public function updateBlocks(){
        $json = array();

        if (!empty($this->request->post['blocks'])) {
            $blocks = json_decode(html_entity_decode($this->request->post['blocks'], ENT_QUOTES, 'UTF-8'), true);
        }

        if (isset($blocks)) {
            foreach ($blocks as $block_id => $block) {
                $setting = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->getSetting($block['setting']['global'], $block['type'], true);
                $blocks[$block_id]['setting']['edit'] = $setting['edit'];
            }

            $json['blocks'] = $blocks;

            $json['success'] = 'success';
        } else {
            $json['error'] = 'error';
        }

        $this->response->addHeader("Content-Type: application/json");
        $this->response->setOutput(json_encode($json, JSON_FORCE_OBJECT));
    }

    public function sort_block($a, $b)
    {
        if ($a['sort_order'] == $b['sort_order']) {
            return 0;
        }
        return ($a['sort_order'] < $b['sort_order']) ? -1 : 1;
    }

    public function getContent()
    {
        $json = array();

        if (isset($this->request->post['setting'])) {
            $setting = json_decode(html_entity_decode($this->request->post['setting'], ENT_QUOTES, 'UTF-8'), true);
        }

        if (isset($setting)) {
            $json['content'] = str_replace('"', '&quot;', $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->parseSetting($setting));
            $json['success'] = 'success';
        } else {
            $json['error'] = 'error';
        }

        $this->response->addHeader('Content-Type: application/json');
        $this->response->setOutput(json_encode($json));
    }

    public function getFileManager()
    {
        $this->load->model('user/user_group');
        $this->model_user_user_group->addPermission($this->user->getGroupId(), 'access', 'extension/dv_elfinder/module/elfinder');
        $this->model_user_user_group->addPermission($this->user->getGroupId(), 'modify', 'extension/dv_elfinder/module/elfinder');

        $data['base'] = HTTP_CATALOG;

        $data['token'] = 'user_token=' . $this->session->data['user_token'];
        $data['route'] = 'extension/dv_elfinder/module/dv_elfinder';

        $this->response->setOutput($this->load->view($data['route'], $data));
    }

    public function getImage()
    {
        $this->load->model('tool/image');
        if (isset($this->request->get['image'])) {
            $this->response->setOutput($this->model_tool_image->resize(html_entity_decode($this->request->get['image'], ENT_QUOTES, 'UTF-8'), 100, 100));
        }
    }

    public function validate()
    {
        $this->error = array();

        $status = $this->config->get($this->codename . '_status');

        if (!$status) {
            $this->error['status'] = $this->language->get('error_status');
        }

        if (!isset($this->request->post['description'])) {
            $this->error['description'] = $this->language->get('error_description');
        }

        if (empty($this->request->post['url'])) {
            $this->error['url'] = $this->language->get('error_url');
        }

        if (!empty($setting['visual_designer_setting']['limit_access_user'])) {
            if (!empty($setting['visual_designer_setting']['access_user']) && !in_array($this->user->getId(), $setting['visual_designer_setting']['access_user'])) {
                $this->error['warning'] = $this->language->get('error_permission');
            } elseif ($setting['visual_designer_setting']['access_user']) {
                $this->error['warning'] = $this->language->get('error_permission');
            }
        }
        if (!empty($setting['visual_designer_setting']['limit_access_user_group'])) {
            if (!empty($setting['visual_designer_setting']['access_user_group']) && !in_array($this->user->getGroupId(), $setting['visual_designer_setting']['access_user_group'])) {
                $this->error['warning'] = $this->language->get('error_permission');
            } elseif (empty($setting['visual_designer_setting']['access_user_group'])) {
                $this->error['warning'] = $this->language->get('error_permission');
            }
        } else {
            $url_info = parse_url(str_replace('&amp;', '&', $this->request->post['url']));
            $url_params = array();

            parse_str($url_info['query'], $url_params);

            $route_info = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->getRouteByBackendRoute($url_params['route']);

            if (empty($route_info)) {
                $this->error['config'] = $this->language->get('error_config');
            }
        }
        return !$this->error;
    }
}
