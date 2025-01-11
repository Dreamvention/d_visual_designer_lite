<?php
namespace Opencart\Admin\Controller\Extension\VisualDesigner\VisualDesigner;

class Setting extends \Opencart\System\Engine\Controller
{
    private $codename = 'visual_designer';
    private $route = 'extension/visual_designer/visual_designer/setting';
    private $extension = '';
    private $store_id = 0;
    private $error = array();

    private $opencart_patch = false;

    public function __construct($registry)
    {
        parent::__construct($registry);

        $this->load->language('extension/visual_designer/module/'.$this->codename);
        $this->load->language($this->route);
        $this->load->model('extension/visual_designer/module/'.$this->codename);
        $this->load->model('extension/visual_designer/'.$this->codename.'/designer');

        $this->opencart_patch = is_file(DIR_EXTENSION . 'dv_opencart_patch/install.json');

        $this->extension = json_decode(file_get_contents(DIR_EXTENSION.'visual_designer/install.json'), true);

        $this->store_id = (isset($this->request->get['store_id'])) ? $this->request->get['store_id'] : 0;
    }

    public function index()
    {
        if (!$this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->checkInstallModule()) {
            $this->welcome();
            return;
        }
        $this->load->model('setting/setting');
		$this->load->model('setting/store');

        // styles and scripts
        $this->document->addStyle(HTTP_CATALOG . 'extension/visual_designer/admin/view/stylesheet/d_bootstrap_extra/bootstrap.css');
        $this->document->addStyle(HTTP_CATALOG . 'extension/visual_designer/admin/view/stylesheet/d_visual_designer/menu.css');

        $this->document->addScript(HTTP_CATALOG . 'extension/visual_designer/admin/view/javascript/d_bootstrap_switch/js/bootstrap-switch.min.js');
        $this->document->addStyle(HTTP_CATALOG . 'extension/visual_designer/admin/view/javascript/d_bootstrap_switch/css/bootstrap-switch.css');
        $this->document->addScript(HTTP_CATALOG . 'extension/visual_designer/admin/view/javascript/d_alertify/alertify.min.js');
        $this->document->addStyle(HTTP_CATALOG . 'extension/visual_designer/admin/view/javascript/d_alertify/css/alertify.min.css');
        $this->document->addStyle(HTTP_CATALOG . 'extension/visual_designer/admin/view/javascript/d_alertify/css/themes/semantic.min.css');

        $url_params = array();

        if (isset($this->response->get['store_id'])) {
            $url_params['store_id'] = $this->store_id;
        }

        $url = ((!empty($url_params)) ? '&' : '') . http_build_query($url_params);

        // Breadcrumbs
        $data['breadcrumbs'] = array();
        $data['breadcrumbs'][] = array(
            'text' => $this->language->get('text_home'),
            'href' => $this->url->link('common/home', 'user_token=' . $this->session->data['user_token'])
            );

        $data['breadcrumbs'][] = array(
            'text'      => $this->language->get('text_module'),
            'href'      => $this->url->link('marketplace/extension', 'user_token=' . $this->session->data['user_token'] . '&type=module')
        );

        $data['breadcrumbs'][] = array(
            'text' => $this->language->get('heading_title_main'),
            'href' => $this->url->link('marketplace/extension', 'user_token=' . $this->session->data['user_token'] . '&' . $url)
        );

        // Notification
        foreach ($this->error as $key => $error) {
            $data['error'][$key] = $error;
        }

        // Heading
        $this->document->setTitle($this->language->get('heading_title_main'));
        $data['heading_title'] = $this->language->get('heading_title_main');
        $data['text_edit'] = $this->language->get('text_edit');

        // Variable
        $data['codename'] = $this->codename;
        $data['route'] = $this->route;
        $data['store_id'] = $this->store_id;
        $data['stores'] = $this->model_setting_store->getStores();
        $data['extension'] = $this->extension;
        $data['version'] = $this->extension['version'];
        $data['token'] = $this->session->data['user_token'];
        $data['url_token'] = 'user_token=' . $this->session->data['user_token'];

        $data['text_enabled'] = $this->language->get('text_enabled');
        $data['text_disabled'] = $this->language->get('text_disabled');
        $data['text_yes'] = $this->language->get('text_yes');
        $data['text_no'] = $this->language->get('text_no');
        $data['text_confirm'] = $this->language->get('text_confirm');
        $data['text_product'] = $this->language->get('text_product');
        $data['text_category'] = $this->language->get('text_category');
        $data['text_information'] = $this->language->get('text_information');
        $data['text_select_all'] = $this->language->get('text_select_all');
        $data['text_unselect_all'] = $this->language->get('text_unselect_all');
        $data['text_complete_version'] = $this->language->get('text_complete_version');

        // Button
        $data['button_add'] = $this->language->get('button_add');
        $data['button_delete'] = $this->language->get('button_delete');
        $data['button_save'] = $this->language->get('button_save');
        $data['button_save_and_stay'] = $this->language->get('button_save_and_stay');
        $data['button_cancel'] = $this->language->get('button_cancel');
        $data['button_remove'] = $this->language->get('button_remove');
        $data['button_compress_update'] = $this->language->get('button_compress_update');

        // Entry
        $data['entry_status'] = $this->language->get('entry_status');
        $data['entry_save_change'] = $this->language->get('entry_save_change');
        $data['entry_save_text'] = $this->language->get('entry_save_text');
        $data['entry_use_designer'] = $this->language->get('entry_use_designer');
        $data['entry_access'] = $this->language->get('entry_access');
        $data['entry_limit_access_user'] = $this->language->get('entry_limit_access_user');
        $data['entry_limit_access_user_group'] = $this->language->get('entry_limit_access_user_group');
        $data['entry_compress_files'] = $this->language->get('entry_compress_files');
        $data['entry_user'] = $this->language->get('entry_user');
        $data['entry_user_group'] = $this->language->get('entry_user_group');
        $data['entry_bootstrap'] = $this->language->get('entry_bootstrap');

        $data['help_save_text'] = $this->language->get('help_save_text');
        $data['help_compress_files'] = $this->language->get('help_compress_files');
        $data['help_bootstrap'] = $this->language->get('help_bootstrap');

        // Text
        $data['text_enabled'] = $this->language->get('text_enabled');
        $data['text_disabled'] = $this->language->get('text_disabled');

        //column
        $data['column_action'] = $this->language->get('column_action');
        $data['column_status'] = $this->language->get('column_status');
        $data['column_route'] = $this->language->get('column_route');
        $data['column_frontend_route'] = $this->language->get('column_frontend_route');
        $data['column_params'] = $this->language->get('column_params');

        $data['column_name'] = $this->language->get('column_name');
        $data['column_text'] = $this->language->get('column_text');

        $data['tab_routes'] = $this->language->get('tab_routes');
        $data['tab_templates'] = $this->language->get('tab_templates');

        //action
        $data['module_link'] = html_entity_decode($this->url->link('extension/visual_designer/module/'.$this->codename, 'user_token=' . $this->session->data['user_token']));

        $data['action'] = html_entity_decode($this->url->link('extension/visual_designer/'.$this->codename.'/setting|save', 'user_token=' . $this->session->data['user_token'] . '&' . $url));

        $data['cancel'] = $this->url->link('marketplace/extension', 'user_token=' . $this->session->data['user_token'] . '&type=module&' . $url);

        $data['get_cancel'] = html_entity_decode($this->url->link('marketplace/extension', 'user_token=' . $this->session->data['user_token'] . '&' . $url));

        $data['compress_action'] = html_entity_decode($this->url->link($this->route.'|compress_update', 'user_token=' . $this->session->data['user_token']));

        $data['tab_setting'] = $this->language->get('tab_setting');
        //support
        $data['tab_support'] = $this->language->get('tab_support');
        $data['text_support'] = $this->language->get('text_support');
        $data['entry_support'] = $this->language->get('entry_support');
        $data['text_no_results'] = $this->language->get('text_no_results');

        $data['text_templates'] = $this->language->get('text_templates');
        $data['text_setting'] = $this->language->get('text_setting');
        $data['text_instructions'] = $this->language->get('text_instructions');

        //instruction
        $data['tab_instruction'] = $this->language->get('tab_instruction');
        $data['text_instruction'] = $this->language->get('text_instruction');


        $data['href_templates'] = $this->url->link('extension/visual_designer/'.$this->codename.'/template', 'user_token=' . $this->session->data['user_token']);
        $data['href_setting'] = $this->url->link('extension/visual_designer/'.$this->codename.'/setting', 'user_token=' . $this->session->data['user_token']);
        $data['href_instruction'] = $this->url->link('extension/visual_designer/'.$this->codename.'/instruction', 'user_token=' . $this->session->data['user_token']);

        if (isset($this->session->data['success'])) {
            $data['success'] = $this->session->data['success'];
            unset($this->session->data['success']);
        } else {
            $data['success'] = '';
        }

        $this->{'model_extension_visual_designer_module_'.$this->codename}->createDatabase();

        $data['landing_notify'] = (!file_exists(DIR_EXTENSION.'visual_designer_landing/install.json'));
        $data['module_notify'] = (!file_exists(DIR_EXTENSION.'visual_designer_module/install.json'));

        if (isset($this->request->post[$this->codename.'_status'])) {
            $data[$this->codename.'_status'] = $this->request->post[$this->codename.'_status'];
        } else {
            $data[$this->codename.'_status'] = $this->config->get($this->codename.'_status');
        }

        //get setting
        $data['setting'] = $this->model_extension_visual_designer_module_visual_designer->getSetting($this->codename);

        $this->load->model('user/user');

        $data['users'] = array();

        if (!empty($data['setting']['access_user'])) {
            foreach ($data['setting']['access_user'] as $user_id) {
                $user_info = $this->model_user_user->getUser($user_id);
                $data['users'][$user_info['user_id']] = $user_info['username'];
            }
        }

        $this->load->model('user/user_group');

        $data['user_groups'] = array();
        if (!empty($data['setting']['access_user_group'])) {
            foreach ($data['setting']['access_user_group'] as $user_group_id) {
                $user_group_info = $this->model_user_user_group->getUserGroup($user_group_id);
                $data['user_groups'][$user_group_id] = $user_group_info['name'];
            }
        }
        $data['routes'] = array();
        $results = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->getRoutes();

        foreach ($results as $key => $value) {
            $data['routes'][$key] = $value['name'];
        }

        $data['header'] = $this->load->controller('common/header');
        $data['column_left'] = $this->load->controller('common/column_left');
        $data['footer'] = $this->load->controller('common/footer');

        $this->response->setOutput($this->load->view($this->route, $data));
    }

    public function save()
    {
        $this->load->model('setting/setting');

        if (isset($this->request->get['store_id'])) {
            $store_id = $this->request->get['store_id'];
        } else {
            $store_id = 0;
        }

        if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validate()) {
            $this->uninstallEvents();

            $this->cache->delete('vd-pre-render');

            if (!empty($this->request->post[$this->codename.'_status']) && !empty($this->request->post[$this->codename.'_setting']['use'])) {
				$this->installEvents($this->request->post[$this->codename.'_setting']['use']);
            }

            $this->model_setting_setting->editSetting($this->codename, $this->request->post, $this->store_id);

            $this->session->data['success'] = $this->language->get('text_success');
        }

        $data['error'] = $this->error;

        if (isset($this->session->data['success'])) {
            $data['success'] = $this->session->data['success'];
            unset($this->session->data['success']);
        } else {
            $data['success'] = '';
        }

        $this->response->setOutput(json_encode($data));
    }

    public function installEvents($status)
    {
        if ($this->opencart_patch) {
            $this->load->model('extension/dv_opencart_patch/setting/event');
            $this->load->model('extension/visual_designer/'.$this->codename.'/designer');
            foreach ($status as $value) {
                $route_info = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->getRoute($value);
                if (!empty($route_info['events'])) {
                    foreach ($route_info['events'] as $trigger => $action) {
                        $this->model_extension_dv_opencart_patch_setting_event->addEvent([
                            'code' => $this->codename,
                            'description' => '',
                            'trigger' => $trigger,
                            'action' => $action,
                            'status' => 1,
                            'sort_order' => 0
                        ]);
                    }
                }
            }

            $this->model_extension_dv_opencart_patch_setting_event->addEvent([
                'code' => $this->codename,
                'description' => '',
                'trigger' => 'admin/model/tool/image/resize/before',
                'action' => 'extension/visual_designer/event/'.$this->codename.'|model_imageResize_before',
                'status' => 1,
                'sort_order' => 0

            ]);
            $this->model_extension_dv_opencart_patch_setting_event->addEvent([
                'code' => $this->codename,
                'description' => '',
                'trigger' => 'catalog/model/tool/image/resize/before',
                'action' => 'extension/visual_designer/event/'.$this->codename.'|model_imageResize_before',
                'status' => 1,
                'sort_order' => 0
            ]);
        }
		
    }

    public function welcome()
    {
        $url_params = array();

        if (isset($this->response->get['store_id'])) {
            $url_params['store_id'] = $this->store_id;
        }

        $url = ((!empty($url_params)) ? '&' : '') . http_build_query($url_params);

        // Breadcrumbs
        $data['breadcrumbs'] = array();
        $data['breadcrumbs'][] = array(
            'text' => $this->language->get('text_home'),
            'href' => $this->url->link('common/home', 'user_token=' . $this->session->data['user_token'])
            );

        $data['breadcrumbs'][] = array(
            'text'      => $this->language->get('text_module'),
            'href'      => $this->url->link('marketplace/extension', 'user_token=' . $this->session->data['user_token'] . '&type=module')
        );

        $data['breadcrumbs'][] = array(
            'text' => $this->language->get('heading_title_main'),
            'href' => $this->url->link('marketplace/extension', 'user_token=' . $this->session->data['user_token'] . '&' . $url)
        );

        // Notification
        foreach ($this->error as $key => $error) {
            $data['error'][$key] = $error;
        }

        // Heading
        $this->document->setTitle($this->language->get('heading_title_main'));
        $data['heading_title'] = $this->language->get('heading_title_main');
        $data['text_edit'] = $this->language->get('text_edit');
        $data['cancel'] = $this->url->link('marketplace/extension', 'user_token=' . $this->session->data['user_token'] . '&type=module');

        $data['version'] = $this->extension['version'];

        $data['text_welcome_title'] = $this->language->get('text_welcome_title');
        $data['text_welcome_description'] = $this->language->get('text_welcome_description');

        $data['text_welcome_visual_editor'] = $this->language->get('text_welcome_visual_editor');
        $data['text_welcome_building_blocks'] = $this->language->get('text_welcome_building_blocks');
        $data['text_welcome_mobile_ready'] = $this->language->get('text_welcome_mobile_ready');
        $data['text_welcome_increase_sales'] = $this->language->get('text_welcome_increase_sales');

        $data['button_setup'] = $this->language->get('button_setup');

        $data['quick_setup'] = html_entity_decode($this->url->link($this->route.'|quickSetup', 'user_token=' . $this->session->data['user_token']));

        $data['header'] = $this->load->controller('common/header');
        $data['column_left'] = $this->load->controller('common/column_left');
        $data['footer'] = $this->load->controller('common/footer');

        $this->response->setOutput($this->load->view('extension/visual_designer/'.$this->codename.'/welcome', $data));
    }

    public function quickSetup()
    {
        $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->installConfig();
        $json['redirect'] = html_entity_decode($this->url->link($this->route, 'user_token=' . $this->session->data['user_token']));
        $this->session->data['success'] = $this->language->get('success_setup');
        $this->response->addHeader('Content-Type: application/json');
        $this->response->setOutput(json_encode($json));
    }

    public function uninstallEvents()
    {
        if ($this->opencart_patch) {
            $this->load->model('extension/dv_opencart_patch/setting/event');
            $this->model_extension_dv_opencart_patch_setting_event->deleteEventByCode($this->codename);
        }
    }

    private function validate($permission = 'modify')
    {
        $this->language->load($this->route);

        if (!$this->user->hasPermission($permission, $this->route)) {
            $this->error['warning'] = $this->language->get('error_permission');
            return false;
        }

        return true;
    }

    public function compress_update()
    {
        $json = array();

        try {
            $this->{'model_extension_visual_designer_module_'.$this->codename}->compressRiotTag();
            $json['success'] = $this->language->get('text_compress_success');
        } catch (Exception $e) {
            $json['error'] = $e->getMessage();
        }

        $this->response->addHeader("Content-Type: application/json");
        $this->response->setOutput(json_encode($json));
    }

    public function autocompleteUser()
    {
        $json = array();

        if (isset($this->request->get['filter_name'])) {
            $this->load->model('user/user');

            $filter_data = array(
                'filter_name' => $this->request->get['filter_name'],
                'start'       => 0,
                'limit'       => 5
                );

            $results = $this->model_user_user->getUsers($filter_data);

            foreach ($results as $result) {
                $json[] = array(
                    'user_id' => $result['user_id'],
                    'username' => strip_tags(html_entity_decode($result['username'], ENT_QUOTES, 'UTF-8'))
                    );
            }
        }

        $sort_order = array();

        foreach ($json as $key => $value) {
            $sort_order[$key] = $value['username'];
        }

        array_multisort($sort_order, SORT_ASC, $json);

        $this->response->addHeader('Content-Type: application/json');
        $this->response->setOutput(json_encode($json));
    }

    public function autocompleteUserGroup()
    {
        $json = array();

        if (isset($this->request->get['filter_name'])) {
            $this->load->model('user/user_group');

            $filter_data = array(
                'filter_name' => $this->request->get['filter_name'],
                'start'       => 0,
                'limit'       => 5
                );

            $results = $this->model_user_user_group->getUserGroups($filter_data);

            foreach ($results as $result) {
                $json[] = array(
                    'user_group_id' => $result['user_group_id'],
                    'name' => strip_tags(html_entity_decode($result['name'], ENT_QUOTES, 'UTF-8'))
                    );
            }
        }

        $sort_order = array();

        foreach ($json as $key => $value) {
            $sort_order[$key] = $value['name'];
        }

        array_multisort($sort_order, SORT_ASC, $json);

        $this->response->addHeader('Content-Type: application/json');
        $this->response->setOutput(json_encode($json));
    }
}
