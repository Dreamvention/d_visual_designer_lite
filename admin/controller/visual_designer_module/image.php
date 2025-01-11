<?php
/*
 *	location: admin/controller
 */
namespace Opencart\Admin\Controller\Extension\VisualDesigner\VisualDesignerModule;

class Image extends \Opencart\System\Engine\Controller
{
    private $codename = 'image';
    private $route = 'extension/visual_designer/visual_designer_module/image';

    public function __construct($registry)
    {
        parent::__construct($registry);

        $this->load->language($this->route);
        $this->load->model($this->route);
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

        return $data;
    }

    public function options(){
        $data = array();

        $this->load->model('tool/image');

        $data['placeholder'] = $this->model_tool_image->resize('no_image.png', 100, 100);

        $data['styles'] = array(
            '' => $this->language->get('text_style_default'),
            'rounded' => $this->language->get('text_style_rounded'),
            'border' => $this->language->get('text_style_border'),
            'outline' => $this->language->get('text_style_outline'),
            'shadow' => $this->language->get('text_style_shadow'),
            'shadow_border' => $this->language->get('text_style_bordered_shadow'),
            'shadow_3d' => $this->language->get('text_style_shadow_3d'),
            'circle' => $this->language->get('text_style_circle'),
            'border_circle' => $this->language->get('text_style_border_circle'),
            'outline_circle' => $this->language->get('text_style_outline_circle'),
            'shadow_circle' => $this->language->get('text_style_shadow_circle'),
            'shadow_border_circle' => $this->language->get('text_style_shadow_border_circle'),
            );

        $data['aligns'] = array(
            'left' => $this->language->get('text_left'),
            'center' => $this->language->get('text_center'),
            'right' => $this->language->get('text_right')
            );

        $data['sizes'] = array(
            'original' => $this->language->get('text_original'),
            'semi_responsive' => $this->language->get('text_semi_responsive'),
            'responsive' => $this->language->get('text_responsive'),
            'small' => $this->language->get('text_small'),
            'medium' => $this->language->get('text_medium'),
            'large' => $this->language->get('text_large'),
            'custom' => $this->language->get('text_custom')
            );

        $data['actions'] = array(
            '' => $this->language->get('text_none'),
            'link' => $this->language->get('text_link'),
            'popup' => $this->language->get('text_popup')
            );

        return $data;
    }

    public function setting($setting)
    {
        $this->load->model('tool/image');

        if (isset($setting['image']) && is_file(DIR_IMAGE . $setting['image'])) {
            $image = $setting['image'];
        } else {
            $image = 'no_image.png';
        }

        $data['thumb'] = $this->model_tool_image->resize($image, 100, 100);

        return $data;
    }

    public function local(){
        $data = array();

        $data['entry_title'] = $this->language->get('entry_title');
        $data['entry_image'] = $this->language->get('entry_image');
        $data['entry_size'] = $this->language->get('entry_size');
        $data['entry_width'] = $this->language->get('entry_width');
        $data['entry_height'] = $this->language->get('entry_height');
        $data['entry_style'] = $this->language->get('entry_style');
        $data['entry_align'] = $this->language->get('entry_align');
        $data['entry_additional_image'] = $this->language->get('entry_additional_image');
        $data['entry_onclick'] = $this->language->get('entry_onclick');
        $data['entry_link'] = $this->language->get('entry_link');
        $data['entry_link_target'] = $this->language->get('entry_link_target');
        $data['entry_alt'] = $this->language->get('entry_alt');
        $data['entry_title'] = $this->language->get('entry_title');
        $data['entry_parallax'] = $this->language->get('entry_parallax');
        $data['entry_parallax_height'] = $this->language->get('entry_parallax_height');
        $data['entry_adaptive_design'] = $this->language->get('entry_adaptive_design');

        $data['column_size'] = $this->language->get('column_size');
        $data['column_align'] = $this->language->get('column_align');
        $data['column_device'] = $this->language->get('column_device');

        $data['text_phone'] = $this->language->get('text_phone');
        $data['text_tablet'] = $this->language->get('text_tablet');

        $data['text_new_window'] = $this->language->get('text_new_window');
        $data['text_current_window'] = $this->language->get('text_current_window');
        $data['text_enabled'] = $this->language->get('text_enabled');
        $data['text_yes'] = $this->language->get('text_yes');
        $data['text_no'] = $this->language->get('text_no');
        $data['text_none'] = $this->language->get('text_none');


        $data['button_remove'] = $this->language->get('button_remove');
        $data['button_image_add'] = $this->language->get('button_image_add');


        return $data;
    }

    public function catalog_styles($permission) {
        $data = array();

        $data[] = 'catalog/view/theme/default/stylesheet/d_visual_designer/blocks/image.css';

        return $data;
    }

}
