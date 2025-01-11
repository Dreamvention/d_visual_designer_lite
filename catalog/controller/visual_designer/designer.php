<?php
namespace Opencart\Catalog\Controller\Extension\VisualDesigner\VisualDesigner;

class Designer extends \Opencart\System\Engine\Controller
{
    private $codename = 'visual_designer';

    private $route = 'extension/visual_designer/visual_designer/designer';

    private $store_url = '';
    private $scripts = array();
    private $error = array();
    private $styles = array();

    public function __construct($registry)
    {
        parent::__construct($registry);

        $this->load->language($this->route);
        $this->load->model('extension/visual_designer/module/' . $this->codename);

        $this->store_url = HTTP_SERVER;
        
		if (file_exists(DIR_EXTENSION . 'visual_designer_module/install.json')) {
			// Template directory
			$this->template->addPath('extension/visual_designer_module', DIR_EXTENSION . 'visual_designer_module/catalog/view/template/');
			// Language directory
			$this->language->addPath('extension/visual_designer_module', DIR_EXTENSION . 'visual_designer_module/catalog/language/');
		}
		if (file_exists(DIR_EXTENSION . 'visual_designer_landing/install.json')) {
			// Template directory
			$this->template->addPath('extension/visual_designer_landing', DIR_EXTENSION . 'visual_designer_landing/catalog/view/template/');
			// Language directory
			$this->language->addPath('extension/visual_designer_landing', DIR_EXTENSION . 'visual_designer_landing/catalog/language/');
		}
    }

    public function index($setting)
    {
        $url_token = '';
        if (isset($this->session->data['user_token']) || isset($this->session->data['token'])) {
            if (VERSION >= '3.0.0.0') {
                $url_token = 'user_token=' . $this->session->data['user_token'];
            } else {
                $url_token = 'token=' . $this->session->data['token'];
            }
        }

        $this->load->model('setting/setting');
        $setting_module = $this->model_setting_setting->getSetting($this->codename);

        if (!empty($setting_module[$this->codename . '_setting'])) {
            $setting_module = $setting_module[$this->codename . '_setting'];
        } else {
            $setting_module = $this->config->get($this->codename . '_setting');
        }

        $data['riot_tags'] = $this->{'model_extension_visual_designer_module_' . $this->codename}->getRiotTags($setting_module['compress_files']);

        if($setting_module['bootstrap']) {
            $this->styles[]  = HTTP_SERVER . 'extension/visual_designer/catalog/view/stylesheet/d_visual_designer/bootstrap.css';
        }

        $result = $this->{'model_extension_visual_designer_module_' . $this->codename}->getContent($setting['config'], $setting['id'], $setting['field_name']);

        if (!empty($result)) {
            $content = $result['content'];
        } else {
            $content = $setting['content'];
        }
        $request_body['route'] = isset($this->request->get['route']) ? $this->request->get['route'] : '';

        $request_body['setting'] = $setting;
        unset($request_body['setting']['header']);

        $this->scripts[] = HTTP_SERVER . 'extension/dv_riot/catalog/view/javascript/dv_riot/riotcompiler.min.js';
        $this->scripts[] = HTTP_SERVER . 'extension/visual_designer/catalog/view/javascript/d_visual_designer/dist/vd-basic-libraries.min.js';
        $this->styles[]  = HTTP_SERVER . 'extension/visual_designer/catalog/view/javascript/d_visual_designer/dist/vd-basic-libraries.min.css';

        $data['designer_id'] = substr(md5(rand()), 0, 7);

        $request_body['designer_id'] = $data['designer_id'];
        if (isset($this->request->get['edit'])) {
            $request_body['edit'] = 1;
        }
        $data['request_body'] = json_encode($request_body);

        $blocks_setting = $this->{'model_extension_visual_designer_module_' . $this->codename}->parseContent($content);

        $this->addScript('javascript/d_visual_designer/main.js');
        $this->addScript('javascript/d_visual_designer/core/block.js');
        $this->addScript('javascript/d_visual_designer/core/component.js');
        $this->addScript('javascript/d_visual_designer/core/sortable.js');
        $this->addScript('javascript/d_visual_designer/model/style.js');
        if ($this->{'model_extension_visual_designer_module_' . $this->codename}->validateEdit($setting['config'])) {
            $this->addStyle('stylesheet/d_visual_designer/d_visual_designer.css');
            $this->addScript('javascript/d_visual_designer/model/block.js');
            $this->addScript('javascript/d_visual_designer/model/content.js');
            $this->addScript('javascript/d_visual_designer/model/history.js');

            $this->prepareScripts(true);
            $this->prepareStyles(true);

            $data['base'] = $this->store_url . 'catalog/view/theme/default/';

            if ($setting['header']) {
                $output = $this->parseHeader($setting['header']);

                if($output) {
                    $setting['header'] = $output;
                }
            } else {
                $this->parseHeader();
            }

            return $this->load->view($this->route, $data);
        } elseif ($this->{'model_extension_visual_designer_module_' . $this->codename}->validateEdit($setting['config'], false) && !empty($setting['id'])) {

            $this->addStyle('stylesheet/d_visual_designer/frontend.css');
            $this->addScript('javascript/d_visual_designer/model/block_front.js');

            $data['edit_url'] = $this->store_url . 'admin/index.php?route=extension/visual_designer/visual_designer/designer|frontend&' . $url_token . '&config=' . $setting['config'] . '&id=' . $setting['id'];

            $data['text_edit'] = $this->language->get('text_edit');

            $this->prepareScripts(false);
            $this->prepareStyles(false);

            $data['content'] = $this->{'model_extension_visual_designer_module_' . $this->codename}->preRender($blocks_setting, $content);


            if ($setting['header']) {
                $output = $this->parseHeader($setting['header']);

                if($output) {
                    $setting['header'] = $output;
                }
            } else {
                $this->parseHeader();
            }

            return $this->load->view('extension/visual_designer/' . $this->codename . '/frontend', $data);
        } else {
            $this->addStyle('stylesheet/d_visual_designer/frontend.css');
            $this->addScript('javascript/d_visual_designer/model/block_front.js');

            $this->prepareScripts(false);
            $this->prepareStyles(false);

            $data['content'] = $this->{'model_extension_visual_designer_module_' . $this->codename}->preRender($blocks_setting, $content);

            if ($setting['header']) {
                $output = $this->parseHeader($setting['header']);

                if($output) {
                    $setting['header'] = $output;
                }
            } else {
                $this->parseHeader();
            }

            return $this->load->view('extension/visual_designer/' . $this->codename . '/frontend', $data);
        }
    }

    public function frontend() {

        if(isset($this->request->get['id'])){
            $id = $this->request->get['id'];
        }

        if(isset($this->request->get['config'])){
            $config = $this->request->get['config'];
        }


        if(isset($this->request->get['field_name'])){
            $field_name = $this->request->get['field_name'];
        }

        if(isset($id) && isset($config) && isset($field_name)) {
            $designer_data = array(
                'config' => $config,
                'content' => '',
                'header' => false,
                'field_name' => $field_name,
                'id' => $id
                );

            $data['content'] = $this->index($designer_data);

            $data['footer'] = $this->load->controller('common/footer');
            $data['header'] = $this->load->controller('common/header');
            $this->response->setOutput($this->load->view('extension/visual_designer/'.$this->codename.'/content', $data));
        } else {
            $data['breadcrumbs'][] = array(
				'text' => $this->language->get('text_error'),
				'href' => $this->url->link('extension/visual_designer/'.$this->codename.'/designer|frontend')
			);

			$this->document->setTitle($this->language->get('text_error'));

			$data['heading_title'] = $this->language->get('text_error');

			$data['text_error'] = $this->language->get('text_error');

			$data['button_continue'] = $this->language->get('button_continue');

			$data['continue'] = $this->url->link('common/home');

			$this->response->addHeader($this->request->server['SERVER_PROTOCOL'] . ' 404 Not Found');

			$data['column_left'] = $this->load->controller('common/column_left');
			$data['column_right'] = $this->load->controller('common/column_right');
			$data['content_top'] = $this->load->controller('common/content_top');
			$data['content_bottom'] = $this->load->controller('common/content_bottom');
            $data['footer'] = $this->load->controller('common/footer');
            $data['header'] = $this->load->controller('common/header');
            $this->response->setOutput($this->load->view('error/not_found', $data));
        }
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
                    $html_dom->find('head > link', -1)->outertext .= '<link href="' . $style . '" rel="stylesheet" type="text/css"/>';
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

    protected function prepareScripts($permission = false)
    {
        $blocks = $this->{'model_extension_visual_designer_module_' . $this->codename}->getBlocks();

        foreach ($blocks as $block) {
            $output = $this->vd_block->load($block, 'scripts', $permission);;
            if (is_array($output)) {
                $this->scripts = array_merge($this->scripts, $output);
            }
        }
    }

    protected function prepareStyles($permission = false)
    {
        $blocks = $this->{'model_extension_visual_designer_module_' . $this->codename}->getBlocks();

        foreach ($blocks as $block) {
            $output = $this->vd_block->load($block, 'styles', $permission);
            if (is_array($output)) {

                $this->styles = array_merge($this->styles, $output);
            }
        }
    }

    protected function prepareLocal($permission = false)
    {
        $local  = array();
        $local['designer']['button_cart']  = $this->language->get('button_cart');
        $local['designer']['button_wishlist'] = $this->language->get('button_wishlist');
        $local['designer']['button_compare']  = $this->language->get('button_compare');

        $local['designer']['text_welcome_header']  = $this->language->get('text_welcome_header');
        $local['designer']['text_add_block']  = $this->language->get('text_add_block');
        $local['designer']['text_add_text_block']  = $this->language->get('text_add_text_block');
        $local['designer']['text_add_template']  = $this->language->get('text_add_template');

        $local['designer']['text_tax'] = $this->language->get('text_tax');

        $blocks = $this->{'model_extension_visual_designer_module_' . $this->codename}->getBlocks();

        $local['blocks'] = array();

        foreach ($blocks as $block) {
            $local['blocks'][$block] = $this->vd_block->load($block, 'local', $permission);
        }

        return $local;
    }

    protected function prepareOptions($permission = false)
    {
        $options = array('designer' => array());

        $blocks = $this->{'model_extension_visual_designer_module_' . $this->codename}->getBlocks();

        $options['blocks'] = array();

        foreach ($blocks as $block) {
            $options['blocks'][$block] = $this->{'model_extension_visual_designer_module_' . $this->codename}->getOptions($block, $permission);
        }

        return $options;
    }

    public function prepareBlocksConfig()
    {
        $blocks = array();

        $this->load->model('tool/image');

        $results = $this->{'model_extension_visual_designer_module_' . $this->codename}->getBlocks();

        foreach ($results as $block) {
            $this->load->language('extension/visual_designer/' . $this->codename . '_module/' . $block);

            $setting = $this->{'model_extension_visual_designer_module_' . $this->codename}->getSettingBlock($block);

            $setting_default = $this->{'model_extension_visual_designer_module_' . $this->codename}->getSetting($setting['setting'], $block);

            if (is_file(DIR_IMAGE . 'catalog/d_visual_designer/' . $block . '.svg')) {
                $image = $this->store_url . 'image/catalog/d_visual_designer/' . $block . '.svg';
            } else {
                $image = $this->model_tool_image->resize('no_image.png', 40, 40);
            }
            if ($setting['display']) {
                $blocks[$block] = array(
                    'title' => $this->language->get('text_title'),
                    'description' => $this->language->get('text_description'),
                    'image' => $image,
                    'type' => $block,
                    'setting_default' => $setting_default,
                    'category' => ucfirst($setting['category']),
                    'sort_order' => isset($setting['sort_order']) ? $setting['sort_order'] : 0,
                    'setting' => $setting
                );
            }
        }
        usort($blocks, 'Opencart\Catalog\Controller\Extension\VisualDesigner\VisualDesigner\Designer::sort_block');

        return $blocks;
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
            $json['setting'] = $this->{'model_extension_visual_designer_module_' . $this->codename}->getSetting($setting['global'], $type);
            $json['success'] = 'success';
        } else {
            $json['error'] = 'error';
        }

        $this->response->addHeader("Content-Type: application/json");
        $this->response->setOutput(json_encode($json, JSON_FORCE_OBJECT));
    }

    public function updateBlocks(){
        $json = array();

        if (!empty($this->request->post['setting'])) {
            $blocks = json_decode(html_entity_decode($this->request->post['setting'], ENT_QUOTES, 'UTF-8'), true);
        }

        if (isset($blocks)) {
            foreach ($blocks as $block_id => $block) {
                $setting = $this->{'model_extension_visual_designer_module_'.$this->codename}->getSetting($block['setting']['global'], $block['type'], true);
                $blocks[$block_id]['setting']['user'] = $setting['user'];
            }

            $json['blocks'] = $blocks;

            $json['success'] = 'success';
        } else {
            $json['error'] = 'error';
        }

        $this->response->addHeader("Content-Type: application/json");
        $this->response->setOutput(json_encode($json, JSON_FORCE_OBJECT));
    }

    public function save()
    {
        $json = array();

        if (isset($this->request->post['setting'])) {
            $setting = json_decode(html_entity_decode($this->request->post['setting'], ENT_QUOTES, 'UTF-8'), true);
        }
        if (isset($this->request->post['id'])) {
            $id = $this->request->post['id'];
        }
        if (isset($this->request->post['route'])) {
            $route = $this->request->post['route'];
        }
        if (isset($this->request->post['field_name'])) {
            $field_name = $this->request->post['field_name'];
        }

        if (isset($setting) && !empty($route) && isset($id) && !empty($field_name)) {
            $content = $this->{'model_extension_visual_designer_module_' . $this->codename}->parseSetting($setting);

            $content_text = $this->{'model_extension_visual_designer_module_' . $this->codename}->getText($setting);

            $route_info = $this->{'model_extension_visual_designer_module_' . $this->codename}->getRoute($route);

            $this->{'model_extension_visual_designer_module_' . $this->codename}->saveContent($content, $route, $id, $field_name);


            $this->load->model('setting/setting');
            $setting_module = $this->model_setting_setting->getSetting($this->codename);

            if (!empty($setting_module[$this->codename . '_setting'])) {
                $setting_module = $setting_module[$this->codename . '_setting'];
            } else {
                $setting_module = $this->config->get($this->codename . '_setting');
            }

            if ($setting_module['save_text'] && !empty($route_info['edit_route'])) {
                $name = '';

                parse_str($field_name . '=' . $content_text, $name);

                $saveData = array(
                    'content' => $name,
                    'id' => $id
                );

                $result = $this->load->controller($route_info['edit_route'], $saveData);
            }

            if (($setting_module['save_text'] && !empty($route_info['edit_route']) && $result) || (!$setting_module['save_text'] || empty($route_info['edit_route']) )) {
                $json['success'] = 'success';
            } else {
                $json['error'] = 'error';
            }
        } else {
            $json['error'] = 'error';
        }

        $this->response->addHeader("Content-Type: application/json");
        $this->response->setOutput(json_encode($json));
    }

    public function get_content_data_via_ajax()
    {
        if (isset($this->request->post['setting'])) {
            $setting = $this->request->post['setting'];

            $result = $setting ? $this->{'model_extension_visual_designer_module_' . $this->codename}->getContent($setting['config'], $setting['id'], $setting['field_name']) : false;

            if ($result && isset($result['content'])) {
                $content = $result['content'];
            } else {
                $content = $setting['content'];
            }

            $blocks_setting = $this->{'model_extension_visual_designer_module_' . $this->codename}->parseContent($content);

            $designer_id = $this->request->post['designer_id'];

            $data['state']['blocks'] = array($designer_id => $blocks_setting);

            $data['state']['drag'] = array();
            $data['state']['drag']= array(
                $designer_id => false
            );

            $data['state']['config'] = array();

            $data['state']['config']['blocks']     = $this->prepareBlocksConfig();
            $data['state']['config']['route']      = array($designer_id => $setting['config']);
            $data['state']['config']['id']         = array($designer_id => $setting['id']);
            $data['state']['config']['field_name'] = array($designer_id => $setting['field_name']);

            if ($this->{'model_extension_visual_designer_module_' . $this->codename}->validateEdit($setting['config'])) {
                $this->load->model('setting/setting');
                $setting_module = $this->model_setting_setting->getSetting($this->codename);

                if (!empty($setting_module[$this->codename . '_setting'])) {
                    $setting_module = $setting_module[$this->codename . '_setting'];
                } else {
                    $setting_module = $this->config->get($this->codename . '_setting');
                }

                $data['state']['history'] = array(
                    $designer_id => array()
                );

                $data['state']['config']['save_change'] = $setting_module['save_change'];

                $data['state']['config']['permission'] = array($designer_id => true);

                $data['local']   = $this->prepareLocal(true);
                $data['options'] = $this->prepareOptions(true);
            } elseif ($this->{'model_extension_visual_designer_module_' . $this->codename}->validateEdit($setting['config'], false) && !empty($setting['id'])) {
                $data['local']   = $this->prepareLocal(false);
                $data['options'] = $this->prepareOptions(false);

                $data['state']['config']['permission'] = array($designer_id => false);
            } else {
                $data['local']   = $this->prepareLocal(false);
                $data['options'] = $this->prepareOptions(false);
                $data['state']['config']['permission'] = array($designer_id => false);
            }

            $this->response->addHeader('Content-Type: application/json');
            $this->response->setOutput(json_encode($data, JSON_FORCE_OBJECT | JSON_NUMERIC_CHECK));
        }
    }


    public function sort_block($a, $b)
    {
        if ($a['sort_order'] == $b['sort_order']) {
            return 0;
        }
        return ($a['sort_order'] < $b['sort_order']) ? -1 : 1;
    }

    public function saveProduct($setting)
    {
        $result = false;

		$this->user = new \Opencart\System\Library\Cart\User($this->registry);

        if (!$this->user->hasPermission('modify', 'catalog/product')) {
            $permission = false;
        } else {
            $permission = true;
        }

        if (!empty($setting['content']['product_description']) && !empty($setting['id']) && $permission) {
            $this->{'model_extension_visual_designer_module_' . $this->codename}->editProduct($setting['id'], $setting['content']);
            $result = true;
        }
        return $result;
    }

    public function saveCategory($setting)
    {
        $result = false;
		$this->user = new \Opencart\System\Library\Cart\User($this->registry);

        if (!$this->user->hasPermission('modify', 'catalog/category')) {
            $permission = false;
        } else {
            $permission = true;
        }

        if (!empty($setting['content']['category_description']) && !empty($setting['id']) && $permission) {
            $this->{'model_extension_visual_designer_module_' . $this->codename}->editCaregory($setting['id'], $setting['content']);

            $result = true;
        }

        return $result;
    }

    public function saveInformation($setting)
    {
        $result = false;

		$this->user = new \Opencart\System\Library\Cart\User($this->registry);

        if (!$this->user->hasPermission('modify', 'catalog/information')) {
            $permission = false;
        } else {
            $permission = true;
        }

        if (isset($setting['content']['information_description']) && !empty($setting['id']) && $permission) {
            $this->{'model_extension_visual_designer_module_' . $this->codename}->editInformation($setting['id'], $setting['content']);

            $result = true;
        }

        return $result;
    }

    protected function addStyle($file)
    {
        $this->styles[] = HTTP_SERVER . 'extension/visual_designer/catalog/view/' . $file;
    }

    protected function addScript($file)
    {
        $this->scripts[] = HTTP_SERVER . 'extension/visual_designer/catalog/view/' . $file;
    }
}
