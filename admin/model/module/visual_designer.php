<?php
namespace Opencart\Admin\Model\Extension\VisualDesigner\Module;

class VisualDesigner extends \Opencart\System\Engine\Model
{
    private $codename = 'visual_designer';

    public function createDatabase()
    {
        $this->db->query("CREATE TABLE IF NOT EXISTS ".DB_PREFIX."visual_designer_template (
            `template_id` INT(11) NOT NULL AUTO_INCREMENT,
            `name` VARCHAR(256) NOT NULL,
            `image` VARCHAR(256) NOT NULL,
            `category` VARCHAR(64) NOT NULL,
            `content` MEDIUMTEXT NULL,
            `sort_order` INT(11) NULL DEFAULT NULL,
            PRIMARY KEY (`template_id`)
            )
            COLLATE='utf8_general_ci' ENGINE=MyISAM;");

        $this->db->query("CREATE TABLE IF NOT EXISTS `".DB_PREFIX."visual_designer_content` (
            `id` INT(11) NOT NULL,
            `route` VARCHAR(64) NOT NULL,
            `field` VARCHAR(256) NOT NULL,
            `content` LONGTEXT NULL,
            PRIMARY KEY (`id`, `route`, `field`)
        )
        COLLATE='utf8_general_ci' ENGINE=MyISAM;");
    }

    public function dropDatabase()
    {
        $this->db->query("DROP TABLE IF EXISTS ".DB_PREFIX."visual_designer_template");
        $this->db->query("DROP TABLE IF EXISTS ".DB_PREFIX."visual_designer_content");
    }

    public function compressRiotTag()
    {
        $this->compressRiotTagByFolder(DIR_EXTENSION.'visual_designer/admin/view/template/visual_designer/');
        $this->compressRiotTagByFolder(DIR_EXTENSION.'visual_designer/catalog/view/template/visual_designer/');

		if (file_exists(DIR_EXTENSION . 'visual_designer_module/install.json')) {
			$this->compressRiotTagByFolder(DIR_EXTENSION.'visual_designer_module/admin/view/template/visual_designer/');
        	$this->compressRiotTagByFolder(DIR_EXTENSION.'visual_designer_module/catalog/view/template/visual_designer/');
		}
		if (file_exists(DIR_EXTENSION . 'visual_designer_landing/install.json')) {
			$this->compressRiotTagByFolder(DIR_EXTENSION.'visual_designer_landing/admin/view/template/visual_designer/');
        	$this->compressRiotTagByFolder(DIR_EXTENSION.'visual_designer_landing/catalog/view/template/visual_designer/');
		}
    }

    protected function compressRiotTagByFolder($folder, $subFolder = false)
    {


        if (is_dir($folder."compress")) {
            array_map('unlink', glob($folder."compress/*"));
        } else {
            mkdir($folder."compress");
        }

        $files = glob($folder . 'components/*.tag', GLOB_BRACE);

        foreach ($files as $file) {
            file_put_contents($folder."compress/component.tag", file_get_contents($file).PHP_EOL, FILE_APPEND);
        }

        $files = glob($folder . 'elements/*.tag', GLOB_BRACE);

        foreach ($files as $file) {
            if ($subFolder && file_exists($subFolder.'elements/'.basename($file))) {
                $file = $subFolder.'elements/'.basename($file);
            }
            file_put_contents($folder."compress/elements.tag", file_get_contents($file).PHP_EOL, FILE_APPEND);
        }

        $files = glob($folder . 'popups/*.tag', GLOB_BRACE);
        foreach ($files as $file) {
            file_put_contents($folder."compress/popups.tag", file_get_contents($file).PHP_EOL, FILE_APPEND);
        }

        $files = glob($folder . 'layouts/*.tag', GLOB_BRACE);
        foreach ($files as $file) {
            file_put_contents($folder."compress/layouts.tag", file_get_contents($file).PHP_EOL, FILE_APPEND);
        }
        $files = glob($folder . 'content_blocks/*.tag', GLOB_BRACE);
        foreach ($files as $file) {
            if ($subFolder && file_exists($subFolder.'content_blocks/'.basename($file))) {
                $file = $subFolder.'content_blocks/'.basename($file);
            }
            file_put_contents($folder."compress/content_blocks.tag", file_get_contents($file).PHP_EOL, FILE_APPEND);
        }
        $files = glob($folder . 'settings_block/*.tag', GLOB_BRACE);
        foreach ($files as $file) {
            file_put_contents($folder."compress/settings_block.tag", file_get_contents($file).PHP_EOL, FILE_APPEND);
        }
        $files = glob($folder . 'layout_blocks/*.tag', GLOB_BRACE);
        foreach ($files as $file) {
            file_put_contents($folder."compress/layout_blocks.tag", file_get_contents($file).PHP_EOL, FILE_APPEND);
        }
    }

    public function ajax($link)
    {
        return str_replace('&amp;', '&', $link);
    }

    public function getGroupId()
    {
        if (VERSION == '2.0.0.0') {
            $user_query = $this->db->query("SELECT * FROM " . DB_PREFIX . "user WHERE user_id = '" . $this->user->getId() . "'");
            $user_group_id = (int)$user_query->row['user_group_id'];
        } else {
            $user_group_id = $this->user->getGroupId();
        }

        return $user_group_id;
    }

    public function getLink($route, $args, $catalog = false)
    {
        $https = $this->request->server['HTTPS'];
        
        if ($catalog) {
            $url = HTTP_CATALOG;
        } else {
            $url = HTTP_SERVER;
        }
        

        $url .= 'index.php?route=' . $route;

        if ($args) {
            if (is_array($args)) {
                $url .= '&amp;' . http_build_query($args);
            } else {
                $url .= str_replace('&', '&amp;', '&' . ltrim($args, '&'));
            }
        }

        return $url;
    }

    /*
    *   Return name of config file.
    */
    public function getConfigFileName($codename)
    {
        if (isset($this->request->post['config'])) {
            return $this->request->post['config'];
        }

        $setting = $this->config->get($codename.'_setting');

        if (isset($setting['config'])) {
            return $setting['config'];
        }

        $full = DIR_SYSTEM . 'config/'. $codename . '.php';
        if (file_exists($full)) {
            return $codename;
        }

        return false;
    }

    public function getSetting($codename, $prefix = '_setting')
    {
        $store_id = (isset($this->request->get['store_id'])) ? $this->request->get['store_id'] : 0;
        $config_file = $this->getConfigFileName($codename);
        $this->config->load($config_file);

        $result = ($this->config->get($codename.$prefix)) ? $this->config->get($codename.$prefix) : array();

        if (!isset($this->request->post['config'])) {
            $this->load->model('setting/setting');
            if (isset($this->request->post[$codename.$prefix])) {
                $setting = $this->request->post;
            } elseif ($this->model_setting_setting->getSetting($codename, $store_id)) {
                $setting = $this->model_setting_setting->getSetting($codename, $store_id);
            }
            if (isset($setting[$codename.$prefix])) {
                foreach ($setting[$codename.$prefix] as $key => $value) {
                    $result[$key] = $value;
                }
            }
        }
        return $result;
    }
}
