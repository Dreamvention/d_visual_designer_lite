<?php

namespace Opencart\Admin\Controller\Extension\VisualDesigner\Module;

class VisualDesigner extends \Opencart\System\Engine\Controller
{
    private $codename = 'visual_designer';
    private $route = 'extension/visual_designer/module/visual_designer';
    private $extension = '';
    private $config_file = '';
    private $store_id = 0;

	private $opencart_patch = false;

    private $error = array();

    public function __construct($registry)
    {
        parent::__construct($registry);

		$this->opencart_patch = is_file(DIR_EXTENSION . 'dv_opencart_patch/install.json');
        $this->load->model($this->route);
        $this->extension = json_decode(file_get_contents(DIR_EXTENSION.'visual_designer/install.json'), true);
    }

    public function index()
    {
		$this->installDependencyModules();
		$data = [];
		$data['non_installed'] = $this->getNonInstalledDependencies();
		if (!$data['non_installed']) {
			$this->load->controller('extension/visual_designer/visual_designer/setting');
		} else {
			$this->load->language('extension/visual_designer/module/'.$this->codename);
			$data['location'] = html_entity_decode($this->url->link('extension/visual_designer/module/'.$this->codename, 'user_token=' . $this->session->data['user_token']));
			$data['user_token'] = $this->session->data['user_token'];
			$data['non_installed'] = json_encode($data['non_installed']);
			$data['header'] = $this->load->controller('common/header');
			$data['column_left'] = $this->load->controller('common/column_left');
			$data['footer'] = $this->load->controller('common/footer');
			$this->response->setOutput($this->load->view('extension/visual_designer/visual_designer/dependencies_installer', $data));
		}
    }

    public function install()
    {
        $this->load->model('user/user_group');

        $this->model_user_user_group->addPermission($this->{'model_extension_visual_designer_module_'.$this->codename}->getGroupId(), 'access', 'extension/visual_designer/'.$this->codename);
        $this->model_user_user_group->addPermission($this->{'model_extension_visual_designer_module_'.$this->codename}->getGroupId(), 'modify', 'extension/visual_designer/'.$this->codename);
        $this->model_user_user_group->addPermission($this->{'model_extension_visual_designer_module_'.$this->codename}->getGroupId(), 'access', 'extension/visual_designer/'.$this->codename.'/designer');
        $this->model_user_user_group->addPermission($this->{'model_extension_visual_designer_module_'.$this->codename}->getGroupId(), 'modify', 'extension/visual_designer/'.$this->codename.'/designer');
        $this->model_user_user_group->addPermission($this->{'model_extension_visual_designer_module_'.$this->codename}->getGroupId(), 'access', 'extension/visual_designer/'.$this->codename.'/setting');
        $this->model_user_user_group->addPermission($this->{'model_extension_visual_designer_module_'.$this->codename}->getGroupId(), 'modify', 'extension/visual_designer/'.$this->codename.'/setting');
        $this->model_user_user_group->addPermission($this->{'model_extension_visual_designer_module_'.$this->codename}->getGroupId(), 'access', 'extension/visual_designer/'.$this->codename.'/template');
        $this->model_user_user_group->addPermission($this->{'model_extension_visual_designer_module_'.$this->codename}->getGroupId(), 'modify', 'extension/visual_designer/'.$this->codename.'/template');
        $this->model_user_user_group->addPermission($this->{'model_extension_visual_designer_module_'.$this->codename}->getGroupId(), 'access', 'extension/visual_designer/'.$this->codename.'/instruction');
        $this->model_user_user_group->addPermission($this->{'model_extension_visual_designer_module_'.$this->codename}->getGroupId(), 'modify', 'extension/visual_designer/'.$this->codename.'/instruction');

        $this->{'model_extension_visual_designer_module_'.$this->codename}->createDatabase();

    }

    public function uninstall()
    {
		if ($this->opencart_patch) {
			$this->load->model('extension/dv_opencart_patch/setting/event');
			$this->model_extension_dv_opencart_patch_setting_event->deleteEventByCode($this->codename);

			$this->{'model_extension_visual_designer_module_'.$this->codename}->dropDatabase();
		}
    }

	private function getNonInstalledDependencies($dependencies = []) {
		$dependencies = $dependencies ? $dependencies : array_keys($this->extension['dependencies']);
		$this->load->model('setting/extension');
		$non_installed = [];
		foreach ($dependencies as $dependency) {
			$install = $this->model_setting_extension->getInstallByCode($dependency);
			if (empty($install['status'])) {
				$non_installed[] = $dependency;
			} else {
				$dependency_extension = json_decode(file_get_contents(DIR_EXTENSION . $dependency . '/install.json'), 1);
				if (!empty($dependency_extension['dependencies'])) {
					$non_installed = array_merge($non_installed, $this->getNonInstalledDependencies(array_keys($dependency_extension['dependencies'])));
				}
			}
		}

		return $non_installed;
	}

	public function installDependencies() {
		$this->load->language('marketplace/installer');

		$json = [];

		$code = $this->request->get['code'] ?? '';

		$page = $this->request->get['page'] ?? 1;

		$this->load->model('setting/extension');

		$extension_install_info = $code ? $this->model_setting_extension->getInstallByCode($code) : [];

		if ($extension_install_info) {
			$file = DIR_STORAGE . 'marketplace/' . $extension_install_info['code'] . '.ocmod.zip';

			if (!is_file($file)) {
				$json['error'] = sprintf($this->language->get('error_file'), $extension_install_info['code'] . '.ocmod.zip');
			}

			if ((int)$page > 1 && !is_dir(DIR_EXTENSION . $extension_install_info['code'] . '/')) {
				$json['error'] = sprintf($this->language->get('error_directory'), $extension_install_info['code'] . '/');
			}
		} else {
			$json['error'] = $this->language->get('error_extension');
		}

		if (!$json) {
			// Unzip the files
			$zip = new \ZipArchive();

			if ($zip->open($file)) {
				$total = $zip->numFiles;
				$limit = 200;

				$start = ((int)$page - 1) * $limit;
				$end = $start > ($total - $limit) ? $total : ($start + $limit);

				// Check if any of the files already exist.
				for ($i = $start; $i < $end; $i++) {
					$source = $zip->getNameIndex($i);

					$destination = str_replace('\\', '/', $source);

					// Only extract the contents of the upload folder
					$path = $extension_install_info['code'] . '/' . $destination;
					$base = DIR_EXTENSION;
					$prefix = '';

					// image > image
					if (substr($destination, 0, 6) == 'image/') {
						$path = $destination;
						$base = substr(DIR_IMAGE, 0, -6);
					}

					// We need to store the path differently for vendor folders.
					if (substr($destination, 0, 15) == 'system/storage/') {
						$path = substr($destination, 15);
						$base = DIR_STORAGE;
						$prefix = 'system/storage/';
					}

					// Must not have a path before files and directories can be moved
					$path_new = '';

					$directories = explode('/', dirname($path));

					foreach ($directories as $directory) {
						if (!$path_new) {
							$path_new = $directory;
						} else {
							$path_new = $path_new . '/' . $directory;
						}

						// To fix storage location
						if (!is_dir($base . $path_new . '/') && mkdir($base . $path_new . '/', 0777)) {
							$this->model_setting_extension->addPath($extension_install_info['extension_install_id'], $prefix . $path_new);
						}
					}

					// If check if the path is not directory and check there is no existing file
					if (substr($source, -1) != '/') {
						if (!is_file($base . $path) && copy('zip://' . $file . '#' . $source, $base . $path)) {
							$this->model_setting_extension->addPath($extension_install_info['extension_install_id'], $prefix . $path);
						}
					}
				}

				$zip->close();
			} else {
				$json['error'] = $this->language->get('error_unzip');
			}
		}

		if (!$json) {
			$json['text'] = sprintf($this->language->get('text_progress'), 2, $total);

			$url = '';

			$url .= '&code=' . $code;


			if (((int)$page * 200) <= $total) {
				$json['next'] = $this->url->link('extension/visual_designer/module/visual_designer|installDependencies', 'user_token=' . $this->session->data['user_token'] . $url . '&page=' . ((int)$page + 1), true);
			} else {
				$this->load->controller('marketplace/installer|vendor');

				$output = json_decode($this->response->getOutput(), 1);

				$json = array_merge($json, $output);

				$extension = json_decode(file_get_contents(DIR_EXTENSION . $code . '/install.json'), 1);
				if (!empty($extension['dependencies'])) {
					$json['dependencies'] = array_keys($extension['dependencies']);
				}
				$this->model_setting_extension->editStatus($extension_install_info['extension_install_id'], 1);
				$this->installDependencyModules([$code]);
			}
		}

		$this->response->addHeader('Content-Type: application/json');
		$this->response->setOutput(json_encode($json));
	}

	public function installDependencyModules($dependencies = []) {
		$this->load->model('setting/extension');

		$available = [];
		$installed = [];
		$available_paths = $this->model_setting_extension->getPaths('%/admin/controller/module/%.php');
		$extensions = $this->model_setting_extension->getExtensionsByType('module');
		$dependencies = $dependencies ? $dependencies : array_keys($this->extension['dependencies']);

		foreach ($available_paths as $available_path) {
			$available[] = basename($available_path['path'], '.php');
		}

		foreach ($extensions as $extension) {
			if (in_array($extension['code'], $available)) {
				$installed[] = $extension['code'];
			} else {
				$this->model_setting_extension->uninstall('module', $extension['code']);
			}
		}

		foreach ($dependencies as $dependency) {
			if (!in_array($dependency, $installed) && file_exists(DIR_EXTENSION . $dependency . '/install.json')) {
				$this->load->model('setting/extension');

				$dependency_extension = json_decode(file_get_contents(DIR_EXTENSION . $dependency . '/install.json'), 1);
				if (!empty($dependency_extension['dependencies'])) {
					$this->installDependencyModules(array_keys($dependency_extension['dependencies']));
				}

				$this->model_setting_extension->install('module', $dependency, $dependency);

				$this->load->model('user/user_group');

				$this->model_user_user_group->addPermission($this->user->getGroupId(), 'access', 'extension/' . $dependency . '/module/' . $dependency);
				$this->model_user_user_group->addPermission($this->user->getGroupId(), 'modify', 'extension/' . $dependency . '/module/' . $dependency);

				$namespace = str_replace(['_', '/'], ['', '\\'], ucwords($dependency, '_/'));

				// Register controllers, models and system extension folders
				$this->autoloader->register('Opencart\Admin\Controller\Extension\\' . $namespace, DIR_EXTENSION . $dependency . '/admin/controller/');
				$this->autoloader->register('Opencart\Admin\Model\Extension\\' . $namespace, DIR_EXTENSION . $dependency . '/admin/model/');
				$this->autoloader->register('Opencart\System\Extension\\' . $namespace, DIR_EXTENSION . $dependency . '/system/');

				// Template directory
				$this->template->addPath('extension/' . $dependency, DIR_EXTENSION . $dependency . '/admin/view/template/');

				// Language directory
				$this->language->addPath('extension/' . $dependency, DIR_EXTENSION . $dependency . '/admin/language/');

				// Config directory
				$this->config->addPath('extension/' . $dependency, DIR_EXTENSION . $dependency . '/system/config/');

				$this->load->controller('extension/' . $dependency . '/module/' . $dependency . '|install');
			}
		}
	}

    public function recompress(){
        $this->{'model_extension_visual_designer_module_'.$this->codename}->compressRiotTag();
    }
}
