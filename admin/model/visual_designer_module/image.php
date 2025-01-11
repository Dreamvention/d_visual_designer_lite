<?php

namespace Opencart\Admin\Model\Extension\VisualDesigner\VisualDesignerModule;

class Image extends \Opencart\System\Engine\Model {

    public function getSize($image, $size, $width, $height){
        if (in_array($size, array('original', 'responsive', 'semi_responsive'))) {
            list($width, $height) = getimagesize(DIR_IMAGE . $image);
            $width .= 'px';
            $height .= 'px';
        } elseif ($size == 'small') {
            $width = ($this->config->get($this->config->get('config_theme') . '_image_category_width') ? $this->config->get($this->config->get('config_theme') . '_image_category_width') : $this->config->get('theme_default_image_category_width')).'px';
            $height = ($this->config->get($this->config->get('config_theme') . '_image_category_height') ? $this->config->get($this->config->get('config_theme') . '_image_category_height') : $this->config->get('theme_default_image_category_height')).'px';
        } elseif ($size == 'medium') {
            $width = '300px';
            $height = '94px';
        } elseif ($size == 'large') {
            $width = '600px';
            $height = '188px';
        } elseif ($size == 'custom') {
            $width = $width;
            $height = $height;
        }
        return array('width' => $width , 'height' => $height);
    }
}
