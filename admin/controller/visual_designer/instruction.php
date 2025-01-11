<?php
namespace Opencart\Admin\Controller\Extension\VisualDesigner\VisualDesigner;

class Instruction extends \Opencart\System\Engine\Controller {
    public $codename = 'visual_designer';
    public $route = 'extension/visual_designer/visual_designer/instruction';
    public $extension = '';
    private $error = array();
    private $input = array();
	private $store_id = 0;

    public function __construct($registry)
    {
        parent::__construct($registry);
        $this->load->language($this->route);
        $this->load->language('extension/visual_designer/module/visual_designer');
        $this->load->model('extension/visual_designer/module/visual_designer');

        $this->extension = json_decode(file_get_contents(DIR_EXTENSION.'visual_designer/install.json'), true);

        $this->store_id = (isset($this->request->get['store_id'])) ? $this->request->get['store_id'] : 0;
    }

    public function index(){

        $this->document->setTitle($this->language->get('heading_title_main'));
        $this->document->addStyle(HTTP_CATALOG . 'extension/visual_designer/admin/view/stylesheet/d_visual_designer/menu.css');

        $this->document->addStyle(HTTP_CATALOG . 'extension/visual_designer/admin/view/stylesheet/d_bootstrap_extra/bootstrap.css');

        $this->load->model('setting/setting');


        $data['heading_title'] = $this->language->get('heading_title_main');
        $data['version'] = $this->extension['version'];
        $data['route'] = $this->route;
        $data['token'] =  $this->session->data['user_token'];

        $data['text_templates'] = $this->language->get('text_templates');
        $data['text_routes'] = $this->language->get('text_routes');
        $data['text_setting'] = $this->language->get('text_setting');
        $data['text_instructions'] = $this->language->get('text_instructions');
        $data['text_instruction_full'] = $this->language->get('text_instruction_full');

        $data['button_cancel'] = $this->language->get('button_cancel');

        $data['breadcrumbs'] = array();

        $data['breadcrumbs'][] = array(
            'text'      => $this->language->get('text_home'),
            'href'      => $this->url->link('common/home', 'user_token=' . $this->session->data['user_token']),
            'separator' => false
            );

        $data['breadcrumbs'][] = array(
            'text'      => $this->language->get('text_module'),
            'href'      => $this->url->link('marketplace/extension','user_token=' . $this->session->data['user_token'] . '&type=module'),
            'separator' => ' :: '
            );

        $data['breadcrumbs'][] = array(
            'text'      => $this->language->get('heading_title_main'),
            'href'      => $this->url->link('extension/visual_designer/module/visual_designer', 'user_token=' . $this->session->data['user_token']),
            'separator' => ' :: '
            );

        $data['cancel'] = $this->url->link('marketplace/extension', 'type=module');

        $data['href_templates'] = $this->url->link('extension/visual_designer/'.$this->codename.'/template', 'user_token=' . $this->session->data['user_token']);
        $data['href_routes'] = $this->url->link('extension/visual_designer/'.$this->codename.'/route', 'user_token=' . $this->session->data['user_token']);
        $data['href_setting'] = $this->url->link('extension/visual_designer/'.$this->codename.'/setting', 'user_token=' . $this->session->data['user_token']);
        $data['href_instruction'] = $this->url->link('extension/visual_designer/'.$this->codename.'/instruction', 'user_token=' . $this->session->data['user_token']);

        $data['header'] = $this->load->controller('common/header');
        $data['column_left'] = $this->load->controller('common/column_left');
        $data['footer'] = $this->load->controller('common/footer');
        $this->response->setOutput($this->load->view($this->route, $data));
    }
}
