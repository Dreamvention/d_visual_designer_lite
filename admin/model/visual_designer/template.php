<?php
/*
*	location: admin/model
*/
namespace Opencart\Admin\Model\Extension\VisualDesigner\VisualDesigner;

class Template extends \Opencart\System\Engine\Model {

    private $sort = 'name';

    private $order = 'ASC';

    /**
     * Add new template
     * @param $data
     * @return mixed
     */
    public function addTemplate($data){
        $this->db->query("INSERT INTO ".DB_PREFIX."visual_designer_template SET
            content='".$this->db->escape($data['content'])."',
            image='".$data['image']."',
            name='".$data['name']."',
            category='".$data['category']."',
            sort_order='".$data['sort_order']."'
        ");
        $template_id = $this->db->getLastId();

        return $template_id;
    }

    /**
     * Edit template
     * @param $template_id
     * @param $data
     */
    public function editTemplate($template_id, $data){
        $this->db->query("UPDATE ".DB_PREFIX."visual_designer_template SET
        content='".$this->db->escape($data['content'])."',
        image='".$data['image']."',
        name='".$data['name']."',
        category='".$data['category']."',
        sort_order='".$data['sort_order']."'
        WHERE template_id='".(int)$template_id."'");
    }

    /**
     * Delete template
     * @param $template_id
     */
    public function deleteTemplate($template_id){
        $this->db->query("DELETE FROM ".DB_PREFIX."visual_designer_template WHERE template_id='".$template_id."'");
    }

    /**
     * Get all templates
     * @param array $data
     * @return array
     */
    public function getTemplates($data=array()){

        $sql = "SELECT * FROM ".DB_PREFIX."visual_designer_template  t ";

        $query = $this->db->query($sql);

        $template_data = array();

        if($query->num_rows){
            foreach ($query->rows as $row) {
                $template_data[] = array(
                    'template_id' => $row['template_id'],
                    'content' => $row['content'],
                    'sort_order' => $row['sort_order'],
                    'name' => $row['name'],
                    'config' => '',
                    'image' => $row['image'],
                    'category' => $row['category']
                );
            }
        }

        $templates_config = $this->getConfigTemplates();

        $template_data = array_merge($template_data, $templates_config);

        $sort_data = array(
            'name',
            'sort_order'
        );

        if (isset($data['sort']) && in_array($data['sort'], $sort_data)) {
            $this->sort = $data['sort'];
        }


        if (isset($data['order']) && ($data['order'] == 'DESC')) {
            $this->order = "DESC";
        } else {
            $this->order = "ASC";
        }

        uasort($template_data, 'Opencart\Admin\Model\Extension\VisualDesigner\VisualDesigner\Template::sort');

        if (isset($data['start']) || isset($data['limit'])) {
            if ($data['start'] < 0) {
                $data['start'] = 0;
            }

            if ($data['limit'] < 1) {
                $data['limit'] = 20;
            }
            $template_data = array_slice($template_data, $data['start'], $data['limit']);
        }

        return $template_data;
    }

    /**
     * Function for sort templates
     * @param $a
     * @param $b
     * @return int
     */
    public function sort($a, $b){
        if($a[$this->sort] < $b[$this->sort]){
            return $this->order=='ASC'?-1:1;
        } else if($a[$this->sort] == $b[$this->sort]){
            return 0;
        } else {
            return $this->order=='ASC'?1:-1;
        }
    }

    /**
     * Get all templates from folder system/config/d_visual_designer_template
     * @return array
     */
    public function getConfigTemplates(){
		$template_data = [];
		$extensions = ['visual_designer_module', 'visual_designer_landing'];

		$_ = [];
		$results = [];

		foreach ($extensions as $extension) {
			$dir = DIR_EXTENSION.$extension.'/system/config/visual_designer_template/';
			if(is_dir($dir)){
				$files = glob($dir.'*.php');
			} else {
				$files = [];
			}

			if ($files) {
				foreach($files as $file){
					if(file_exists($file)){

						require($file);

						$results = array_merge($results, $_);

						$templates = $results['visual_designer_templates'];
						foreach ($templates as $template) {
							$template_data[] = array(
								'template_id' => $template['template_id'],
								'content' => $template['content'],
								'config' => basename($file, '.php'),
								'image' => $template['image'],
								'category' => $template['category'],
								'sort_order' => $template['sort_order'],
								'name' => $template['name']
							);
						}
					}
				}
			}
		}

        return $template_data;
    }

    /**
     * Get template by template_id
     * @param $template_id
     * @return mixed
     */
    public function getTemplate($template_id){
        $query = $this->db->query("SELECT * FROM ".DB_PREFIX."visual_designer_template t WHERE t.template_id='".(int)$template_id."'");

        return $query->row;
    }

    /**
     * Get template from folder system/config/d_visual_designer_template
     * by template_id and file name
     * @param $template_id
     * @param $config
     * @return array
     */
    public function getConfigTemplate($template_id, $config){
        $_ = array();

        $results = array();

		if (file_exists(DIR_EXTENSION.'visual_designer/system/config/visual_designer_template/'.$config.'.php')) {
			require DIR_EXTENSION.'visual_designer/system/config/visual_designer_template/'.$config.'.php';
		} else if (file_exists(DIR_EXTENSION.'visual_designer_module/system/config/visual_designer_template/'.$config.'.php')) {
			require DIR_EXTENSION.'visual_designer_module/system/config/visual_designer_template/'.$config.'.php';
		} else if (file_exists(DIR_EXTENSION.'visual_designer_landing/system/config/visual_designer_template/'.$config.'.php')) {
			require DIR_EXTENSION.'visual_designer_landing/system/config/visual_designer_template/'.$config.'.php';
		}

        $results = array_merge($results, $_);

        $templates = $results['visual_designer_templates'];

        foreach ($templates as $template) {
            if($template['template_id'] == $template_id){
                return $template;
            }
        }
        return array();
    }

    /**
     * Get total templates
     * @return int
     */
    public function getTotalTemplates(){
        $query = $this->db->query("SELECT count(*) as total FROM ".DB_PREFIX."visual_designer_template t ");

        $templates_config = $this->getConfigTemplates();

        return $query->row['total']+count($templates_config);
    }
}
