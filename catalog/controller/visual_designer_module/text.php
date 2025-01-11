<?php
/*
 *  location: admin/controller
 */
namespace Opencart\Catalog\Controller\Extension\VisualDesigner\VisualDesignerModule;

class Text extends \Opencart\System\Engine\Controller
{
    private $codename = 'text';
    private $route = 'extension/visual_designer/visual_designer_module/text';

    public function __construct($registry)
    {
        parent::__construct($registry);

        $this->load->language($this->route);
    }

    public function index($setting)
    {
        $data['text'] = html_entity_decode(htmlspecialchars_decode($setting['text']), ENT_QUOTES, 'UTF-8');

        return $data;
    }
}
