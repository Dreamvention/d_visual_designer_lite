<?php
/*
 *	location: admin/controller
 */
namespace Opencart\Catalog\Controller\Extension\VisualDesigner\VisualDesignerModule;

class Image extends \Opencart\System\Engine\Controller
{
    private $codename = 'image';
    private $route = 'extension/visual_designer/visual_designer_module/image';

    public function __construct($registry)
    {
        parent::__construct($registry);

        $this->load->language($this->route);
    }
    public function index($setting)
    {
        $this->load->model('tool/image');

        if (!empty($setting['image']) && is_file(DIR_IMAGE . $setting['image'])) {
            $image = $setting['image'];
        } else {
            $image = 'no_image.png';
        }

        list($width, $height) = getimagesize(DIR_IMAGE . $image);

        $data['thumb'] = $this->model_tool_image->resize($image, $width, $height);


        $popup_width = $this->config->get('config_image_popup_width');
    	$popup_height = $this->config->get('config_image_popup_height');

        $data['popup'] = $this->model_tool_image->resize($image, $popup_width, $popup_height);

        return $data;
    }

    public function styles($permission) {
        $data = array();

        $data[] = 'extension/visual_designer/catalog/view/stylesheet/d_visual_designer/blocks/image.css';

        return $data;
    }
}
