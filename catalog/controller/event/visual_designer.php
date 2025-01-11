<?php
namespace Opencart\Catalog\Controller\Extension\VisualDesigner\Event;

class VisualDesigner extends \Opencart\System\Engine\Controller
{
    private $codename = 'visual_designer';

    private $route = 'extension/visual_designer/module/visual_designer';

    public function __construct($registry)
    {
        parent::__construct($registry);

        $this->load->language($this->route);
        $this->load->model($this->route);
    }

    public function view_product_before(&$view, &$data)
    {
        if (isset($data['description'])) {
            $designer_data = array(
                'config' => 'product',
                'content' => $data['description'],
                'header' => &$data['header'],
                'field_name' => 'product_description['.(int)$this->config->get('config_language_id').'][description]',
                'id' => $data['product_id']
                );

            $data['description'] = $this->load->controller('extension/visual_designer/'.$this->codename.'/designer', $designer_data);

            $data['description'] = html_entity_decode($data['description'], ENT_QUOTES, 'UTF-8');
        }
    }


    public function view_category_before(&$view, &$data)
    {
        $parts = explode('_', (string)$this->request->get['path']);

        $category_id = (int)array_pop($parts);

        if (isset($data['description'])) {
            $designer_data = array(
                'config' => 'category',
                'content' => $data['description'],
                'header' => &$data['header'],
                'field_name' => 'category_description['.(int)$this->config->get('config_language_id').'][description]',
                'id' => $category_id
                );

            $data['description'] = $this->load->controller('extension/visual_designer/'.$this->codename.'/designer', $designer_data);

            $data['description'] = html_entity_decode($data['description'], ENT_QUOTES, 'UTF-8');
        }
    }

    public function view_information_before(&$view, &$data)
    {
        if (isset($data['description']) && !empty($this->request->get['information_id'])) {
            $designer_data = array(
                'config' => 'information',
                'content' => $data['description'],
                'header' => &$data['header'],
                'field_name' => 'information_description['.(int)$this->config->get('config_language_id').'][description]',
                'id' => (int)$this->request->get['information_id']
                );
            $data['description'] = $this->load->controller('extension/visual_designer/'.$this->codename.'/designer', $designer_data);

            $data['description'] = html_entity_decode($data['description'], ENT_QUOTES, 'UTF-8');
        }
    }

    public function model_imageResize_before(&$route, &$data)
    {
        if (isset($this->request->server['HTTPS']) && (($this->request->server['HTTPS'] == 'on') || ($this->request->server['HTTPS'] == '1'))) {
            $server = $this->config->get('config_ssl');
        } else {
            $server = $this->config->get('config_url');
        }

        if (!empty($data[0])) {
            $image_info = (is_file(DIR_IMAGE . $data[0]) ? @getimagesize(DIR_IMAGE . $data[0]) : []);
            if (!$image_info) {
                return $server . 'image/' . $data[0];
            }
        } else {
            $data[0] = "no_image.png";
        }
    }
}
