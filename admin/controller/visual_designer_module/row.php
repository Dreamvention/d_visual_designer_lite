<?php
/*
 *  location: admin/controller
 */
namespace Opencart\Admin\Controller\Extension\VisualDesigner\VisualDesignerModule;

class Row extends \Opencart\System\Engine\Controller
{
    private $codename = 'row';
    private $route = 'extension/visual_designer/visual_designer_module/row';

    public function __construct($registry)
    {
        parent::__construct($registry);

        $this->load->language($this->route);
    }

    public function options(){
        $data = array();

        $data['stretchs'] = array(
            '' => $this->language->get('text_default'),
            'stretch_row' => $this->language->get('text_stretch_row'),
            'stretch_row_content' => $this->language->get('text_stretch_row_content'),
            'stretch_row_content_left' => $this->language->get('text_stretch_row_content_left'),
            'stretch_row_content_right' => $this->language->get('text_stretch_row_content_right'),
            'stretch_row_content_no_spaces' => $this->language->get('text_stretch_row_content_no_spaces')
        );
        $data['layout_sizes'] = array('12', '6+6', '4+4+4', '3+3+3+3', '8+4', '4+8', '3+9', '9+3', '6+3+3', '3+3+6', '3+6+3');

        $data['aligns'] = array(
            'left' => $this->language->get('text_left'),
            'center' => $this->language->get('text_center'),
            'right' => $this->language->get('text_right')
        );

        $data['align_items'] = array(
            'start' => $this->language->get('text_start'),
            'center' => $this->language->get('text_center'),
            'end' => $this->language->get('text_end'),
            'stretch' => $this->language->get('text_stretch'),
            'baseline' => $this->language->get('text_baseline')
        );
        $data['containers'] = array(
            'fluid' => $this->language->get('text_fluid'),
            'responsive' => $this->language->get('text_responsive')
        );

        return $data;
    }

    public function local()
    {
        $data = array();

        $data['entry_background_video'] = $this->language->get('entry_background_video');
        $data['entry_video_link'] = $this->language->get('entry_video_link');
        $data['entry_container'] = $this->language->get('entry_container');
        $data['entry_row_stretch'] = $this->language->get('entry_row_stretch');
        $data['entry_align'] = $this->language->get('entry_align');
        $data['entry_align_items'] = $this->language->get('entry_align_items');

        $data['text_enabled'] = $this->language->get('text_enabled');
        $data['text_yes'] = $this->language->get('text_yes');
        $data['text_no'] = $this->language->get('text_no');
        $data['text_set_custom'] = $this->language->get('text_set_custom');

        return $data;
    }
}
