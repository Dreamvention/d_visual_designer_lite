<?php
namespace Opencart\Admin\Controller\Extension\VisualDesigner\Event;

class VisualDesigner extends \Opencart\System\Engine\Controller
{
    private $codename = 'visual_designer';
    private $setting_module = array();

    public function __construct($registry)
    {
        parent::__construct($registry);
        $this->load->model('extension/visual_designer/'.$this->codename.'/designer');

        $this->load->model('setting/setting');
        $this->setting_module = $this->model_setting_setting->getSetting($this->codename);

        if (!empty($this->setting_module[$this->codename.'_setting'])) {
            $this->setting_module = $this->setting_module[$this->codename.'_setting'];
        } else {
            $this->setting_module = $this->config->get($this->codename.'_setting');
        }
    }

    public function view_product_after(&$route, &$data, &$output)
    {
        $designer_data = array(
        'config' => 'product',
        'output' => &$output,
        'id' => !empty($this->request->get['product_id'])?$this->request->get['product_id']:false
        );
        $vd_content = $this->load->controller('extension/visual_designer/'.$this->codename.'/designer', $designer_data);

        if (
            !class_exists('\\Opencart\\System\\Library\\Extension\\DvSimpleHtmlDom\\DvSimpleHtmlDom') && 
            is_file(DIR_EXTENSION . 'dv_simple_html_dom/system/library/dv_simple_html_dom.php')
        ) {
            require_once DIR_EXTENSION . 'dv_simple_html_dom/system/library/dv_simple_html_dom.php';
        }

        $html_dom = new \Opencart\System\Library\Extension\DvSimpleHtmlDom\DvSimpleHtmlDom();
        $html_dom->load($output, $lowercase = true, $stripRN = false, $defaultBRText = DEFAULT_BR_TEXT);

        $this->load->model('localisation/language');

        $languages = $this->model_localisation_language->getLanguages();

        foreach ($languages as $language) {
            $el = $html_dom->find('textarea[name^="product_description['.$language['language_id'].'][description"]', 0);
            $field_data = array(
                'field' => "product_description[".$language['language_id']."][description]",
                'content' => htmlspecialchars($el->innertext)
            );
            $designer_content = $this->load->controller('extension/visual_designer/'.$this->codename.'/designer|field', $field_data);
            $el->parent()->parent()->parent()->parent()->outertext = $designer_content . $el->parent()->parent()->parent()->parent()->outertext;
        }

        $html_dom->find('body', 0)->innertext .= $vd_content;


        $output = (string)$html_dom;
    }

    public function model_catalog_product_addProduct_before(&$route, &$data)
    {
        if ($this->setting_module['save_text']) {
            $this->load->model('localisation/language');

            $languages = $this->model_localisation_language->getLanguages();

            foreach ($languages as $language) {
                $field_name = rawurlencode("product_description[".$language['language_id']."][description]");
                if (!empty($data[0]['vd_content'][$field_name])) {
                    $setting = json_decode(html_entity_decode($data[0]['vd_content'][$field_name], ENT_QUOTES, 'UTF-8'), true);
                    $data[0]['product_description'][$language['language_id']]['description'] = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->getText($setting);
                }
            }
        }
    }
    public function model_catalog_product_addProduct_after(&$route, &$data, &$output)
    {
        foreach ($data[0]['vd_content'] as $field_name => $setting_json) {
            $setting = json_decode(html_entity_decode($setting_json, ENT_QUOTES, 'UTF-8'), true);
            $content = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->parseSetting($setting);
            $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->saveContent($content, 'product', $output, rawurldecode($field_name));
        }
    }
    public function model_catalog_product_editProduct_before(&$route, &$data)
    {
        if ($this->setting_module['save_text']) {
            $this->load->model('localisation/language');

            $languages = $this->model_localisation_language->getLanguages();

            foreach ($languages as $language) {
                $field_name = rawurlencode("product_description[".$language['language_id']."][description]");
                if (!empty($data[1]['vd_content'][$field_name])) {
                    $setting = json_decode(html_entity_decode($data[1]['vd_content'][$field_name], ENT_QUOTES, 'UTF-8'), true);
                    $data[1]['product_description'][$language['language_id']]['description'] = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->getText($setting);
                }
            }
        }
    }
    public function model_catalog_product_editProduct_after(&$route, &$data, &$output)
    {
        foreach ($data[1]['vd_content'] as $field_name => $setting_json) {
            $setting = json_decode(html_entity_decode($setting_json, ENT_QUOTES, 'UTF-8'), true);
            $content = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->parseSetting($setting);
            $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->saveContent($content, 'product', $data[0], rawurldecode($field_name));
        }
    }

    public function view_category_after(&$route, &$data, &$output)
    {
        $designer_data = array(
            'config' => 'category',
            'output' => &$output,
            'id' => !empty($this->request->get['category_id'])?$this->request->get['category_id']:false
        );

        $vs_content = $this->load->controller('extension/visual_designer/'.$this->codename.'/designer', $designer_data);

        if (
            !class_exists('\\Opencart\\System\\Library\\Extension\\DvSimpleHtmlDom\\DvSimpleHtmlDom') && 
            is_file(DIR_EXTENSION . 'dv_simple_html_dom/system/library/dv_simple_html_dom.php')
        ) {
            require_once DIR_EXTENSION . 'dv_simple_html_dom/system/library/dv_simple_html_dom.php';
        }

        $html_dom = new \Opencart\System\Library\Extension\DvSimpleHtmlDom\DvSimpleHtmlDom();
        $html_dom->load($output, $lowercase = true, $stripRN = false, $defaultBRText = DEFAULT_BR_TEXT);

        $this->load->model('localisation/language');

        $languages = $this->model_localisation_language->getLanguages();

        foreach ($languages as $language) {
            $el = $html_dom->find('textarea[name^="category_description['.$language['language_id'].'][description"]', 0);
            $field_data = array(
                'field' => "category_description[".$language['language_id']."][description]",
                'content' => htmlspecialchars($el->innertext)
            );
            $designer_content = $this->load->controller('extension/visual_designer/'.$this->codename.'/designer|field', $field_data);
            $el->parent()->parent()->outertext = $designer_content . $el->parent()->parent()->outertext;
        }

        $html_dom->find('body', 0)->innertext .= $vs_content;

        $output = (string)$html_dom;
    }

    public function model_catalog_category_addCategory_before(&$route, &$data)
    {
        if ($this->setting_module['save_text']) {
            $this->load->model('localisation/language');

            $languages = $this->model_localisation_language->getLanguages();

            foreach ($languages as $language) {
                $field_name = rawurlencode("category_description[".$language['language_id']."][description]");
                if (!empty($data[0]['vd_content'][$field_name])) {
                    $setting = json_decode(html_entity_decode($data[0]['vd_content'][$field_name], ENT_QUOTES, 'UTF-8'), true);
                    $data[0]['category_description'][$language['language_id']]['description'] = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->getText($setting);
                }
            }
        }
    }
    public function model_catalog_category_addCategory_after(&$route, &$data, &$output)
    {
        foreach ($data[0]['vd_content'] as $field_name => $setting_json) {
            $setting = json_decode(html_entity_decode($setting_json, ENT_QUOTES, 'UTF-8'), true);
            $content = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->parseSetting($setting);
            $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->saveContent($content, 'category', $output, rawurldecode($field_name));
        }
    }
    public function model_catalog_category_editCategory_before(&$route, &$data)
    {
        if ($this->setting_module['save_text']) {
            $this->load->model('localisation/language');

            $languages = $this->model_localisation_language->getLanguages();

            foreach ($languages as $language) {
                $field_name = rawurlencode("category_description[".$language['language_id']."][description]");
                if (!empty($data[1]['vd_content'][$field_name])) {
                    $setting = json_decode(html_entity_decode($data[1]['vd_content'][$field_name], ENT_QUOTES, 'UTF-8'), true);
                    $data[1]['category_description'][$language['language_id']]['description'] = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->getText($setting);
                }
            }
        }
    }
    public function model_catalog_category_editCategory_after(&$route, &$data, &$output)
    {
        foreach ($data[1]['vd_content'] as $field_name => $setting_json) {
            $setting = json_decode(html_entity_decode($setting_json, ENT_QUOTES, 'UTF-8'), true);
            $content = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->parseSetting($setting);
            $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->saveContent($content, 'category', $data[0], rawurldecode($field_name));
        }
    }

    public function view_information_after(&$route, &$data, &$output)
    {
        $designer_data = array(
            'config' => 'information',
            'output' => &$output,
            'id' => !empty($this->request->get['information_id'])?$this->request->get['information_id']:false
        );

        $vd_content = $this->load->controller('extension/visual_designer/'.$this->codename.'/designer', $designer_data);

        if (
            !class_exists('\\Opencart\\System\\Library\\Extension\\DvSimpleHtmlDom\\DvSimpleHtmlDom') && 
            is_file(DIR_EXTENSION . 'dv_simple_html_dom/system/library/dv_simple_html_dom.php')
        ) {
            require_once DIR_EXTENSION . 'dv_simple_html_dom/system/library/dv_simple_html_dom.php';
        }

        $html_dom = new \Opencart\System\Library\Extension\DvSimpleHtmlDom\DvSimpleHtmlDom();
        $html_dom->load($output, $lowercase = true, $stripRN = false, $defaultBRText = DEFAULT_BR_TEXT);

        $this->load->model('localisation/language');

        $languages = $this->model_localisation_language->getLanguages();

        foreach ($languages as $language) {
            $el = $html_dom->find('textarea[name^="information_description['.$language['language_id'].'][description"]', 0);
            $field_data = array(
                'field' => "information_description[".$language['language_id']."][description]",
                'content' => htmlspecialchars($el->innertext)
            );
            $designer_content = $this->load->controller('extension/visual_designer/'.$this->codename.'/designer|field', $field_data);
            $el->parent()->parent()->parent()->outertext = $designer_content . $el->parent()->parent()->parent()->outertext;
        }

        $html_dom->find('body', 0)->innertext .= $vd_content;

        $output = (string)$html_dom;
    }

    public function model_catalog_infromation_addInformation_before(&$route, &$data)
    {
        if ($this->setting_module['save_text']) {
            $this->load->model('localisation/language');

            $languages = $this->model_localisation_language->getLanguages();

            foreach ($languages as $language) {
                $field_name = rawurlencode("information_description[".$language['language_id']."][description]");
                if (!empty($data[0]['vd_content'][$field_name])) {
                    $setting = json_decode(html_entity_decode($data[0]['vd_content'][$field_name], ENT_QUOTES, 'UTF-8'), true);
                    $data[0]['information_description'][$language['language_id']]['description'] = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->getText($setting);
                }
            }
        }
    }
    public function model_catalog_infromation_addInformation_after(&$route, &$data, &$output)
    {
        foreach ($data[0]['vd_content'] as $field_name => $setting_json) {
            $setting = json_decode(html_entity_decode($setting_json, ENT_QUOTES, 'UTF-8'), true);
            $content = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->parseSetting($setting);
            $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->saveContent($content, 'information', $output, rawurldecode($field_name));
        }
    }
    public function model_catalog_infromation_editInformation_before(&$route, &$data)
    {
        if ($this->setting_module['save_text']) {
            $this->load->model('localisation/language');

            $languages = $this->model_localisation_language->getLanguages();

            foreach ($languages as $language) {
                $field_name = rawurlencode("information_description[".$language['language_id']."][description]");
                if (!empty($data[1]['vd_content'][$field_name])) {
                    $setting = json_decode(html_entity_decode($data[1]['vd_content'][$field_name], ENT_QUOTES, 'UTF-8'), true);
                    $data[1]['information_description'][$language['language_id']]['description'] = $this->{'model_extension_'.$this->codename.'_designer'}->getText($setting);
                }
            }
        }
    }
    public function model_catalog_infromation_editInformation_after(&$route, &$data, &$output)
    {
        foreach ($data[1]['vd_content'] as $field_name => $setting_json) {
            $setting = json_decode(html_entity_decode($setting_json, ENT_QUOTES, 'UTF-8'), true);
            $content = $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->parseSetting($setting);
            $this->{'model_extension_visual_designer_'.$this->codename.'_designer'}->saveContent($content, 'information', $data[0], rawurldecode($field_name));
        }
    }

    public function model_imageResize_before(&$route, &$data)
    {
        $server = HTTP_CATALOG;

        if (!empty($data[0])) {
            $image_info = @getimagesize(DIR_IMAGE . $data[0]);
            if (!$image_info) {
                return $server . 'image/' . $data[0];
            }
        } else {
            $data[0] = "no_image.png";
        }
    }
}
