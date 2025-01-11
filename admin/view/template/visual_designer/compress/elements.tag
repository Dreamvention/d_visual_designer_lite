<vd-adaptive-checkbox>
    <label class="vd-checkbox">
        <input type="checkbox" name="{opts.name}" value="show_mobile" checked={_.contains(opts.riotValue, 'show_mobile')} onChange={change}> {store.getLocal('designer.text_phone')}
    </label>
    <br>
    <label class="vd-checkbox">
        <input type="checkbox" name="{opts.name}" value="show_tablet" checked={_.contains(opts.riotValue, 'show_tablet')} onChange={change}> {store.getLocal('designer.text_tablet')}
    </label>
    <br>
    <label class="vd-checkbox">
        <input type="checkbox" name="{opts.name}" value="show_desktop" checked={_.contains(opts.riotValue, 'show_desktop')} onChange={change}> {store.getLocal('designer.text_desktop')}
    </label>
    <script>
        this.mixin({store:d_visual_designer})
        change(e) {
            var values = _.values(this.opts.riotValue)
            if(e.target.checked) {
                values.push(e.target.value)
            } else {
                values = _.filter(values, function(name) {
                    return name != e.target.value
                })
            }
            this.opts.evchange({
                currentTarget: {
                    name: this.opts.name,
                    value: values
                },
                target: {
                    name: this.opts.name,
                    value: values
                },
            })
        }
    </script>
</vd-adaptive-checkbox>
<vd-autocomplete-well>
    <input type="text" class="form-control" name="autocomplete_text" value={autocomplete_text} />
    <div class="well well-sm" style="height: 150px; overflow: auto;">
        <div each={option in options}><i class="fa fa-minus-circle" onClick={removeItem}></i> {option.name}</div>
    </div>
    <script>
        this.autocomplete_text = ''
        this.options = _.values(this.opts.options)
        removeItem(e) {
            this.options = _.filter(this.options, function(option){
                return e.item.option.id != option.id
            })
            this.opts.evchange({target: {
                name: this.opts.name,
                value: _.map(this.options, function(option) {
                    return option.id;
                })
            }})
            this.update()
        }
        this.on('mount', function(){
            $('input', this.root).autocomplete({
                'source': function(request, response) {
                    $.ajax({
                        url: this.opts.url+'&filter_name=' +  encodeURIComponent(request),
                        dataType: 'json',
                        success: function(json) {
                            response($.map(json, function(item) {
                                return {
                                    label: item['name'],
                                    value: item['id']
                                }
                            }));
                        }
                    });
                }.bind(this),
                'select': function(item) {
                    this.autocomplete_text = ''
                    this.options = _.filter(this.options, function(option){
                        return item.value != option.id
                    })
                    this.options.push({id: item.value, name: item.label})
                    this.opts.evchange({target: {
                        name: this.opts.name,
                        value: _.map(this.options, function(option) {
                            return option.id;
                        })
                    }})
                    this.update()
                }.bind(this)
            });
        })
    </script>
</vd-autocomplete-well>

<vd-autocomplete>
    <input type="text" class="form-control" name="autocomplete_text" list="list-text" value={autocomplete_text} />
	<datalist id="list-text"></datalist>
    <script>
        this.autocomplete_text = ''
        this.on('mount', function(){
            if(!_.isEmpty(this.opts.riotValue)) {
                $.ajax({
                    url: this.opts.url+'&filter_id=' +  encodeURIComponent(this.opts.riotValue),
                    dataType: 'json',
                    context: this,
                    success: function(json) {
                        if(!_.isUndefined(json[0])){
                            this.autocomplete_text = json[0]['name']
                            this.update()
                        }
                    }
                })
            }
            $('input', this.root).autocomplete({
                'source': function(request, response) {
                    $.ajax({
                        url: this.opts.url+'&filter_name=' +  encodeURIComponent(request),
                        dataType: 'json',
                        success: function(json) {
                            response($.map(json, function(item) {
                                return {
                                    label: item['name'],
                                    value: item['id']
                                }
                            }));
                        }
                    });
                }.bind(this),
                'select': function(item) {
                     this.autocomplete_text = item['label']
                    this.opts.evchange({target: {
                        name: this.opts.name,
                        value: item['value']

                    }})
                }.bind(this)
            });
        })
    </script>
</vd-autocomplete>

<vd-ckeditor>
	<textarea class="form-control" data-vd-toggle="ckeditor" name={opts.name}>{opts.riotValue}</textarea>
	<script>
	this.on('mount', function(){
		that = this;
		$('textarea[data-vd-toggle=\'ckeditor\']').ckeditor({
			language: that.opts.language
		});
		CKEDITOR.instances[that.opts.name].on('change', function() {
			that.opts.evchange(that.opts.name, e.CKEDITOR.instances[that.opts.name].getData());
		});
	});
	</script>
</vd-ckeditor>

<vd-collapse-item>
    <div class="vd-collapse-title" onclick={parent.clickTab}>{opts.title}</div>
    <div class="vd-collapse-content {parent.active == tab ? 'active' : null}"><yield/></div>
    <script>
        this.mixin({store:d_visual_designer})
        this.top = this.parent.top
    </script>
</vd-collapse-item>
<vd-collapse>
    <div class="vd-collapse {active != ''? 'active' : ''}">
        <div class="vd-collpase-back" ><i class="fas fa-chevron-double-left" onclick={clickBack}></i></div>
        <yield/>
    </div>
    <script>
        this.mixin({store:d_visual_designer})
        this.active = ''
        this.top = this.parent
        this.clickTab = function(e) {
            this.active = e.item.tab
            $(this.parent.root).children('div').hide()
            this.update()
        }.bind(this)
        clickBack = function(e) {
            this.active = ''
            $(this.parent.root).children('div').show()
            this.update()
        }.bind(this)
    </script>
</vd-collapse>
<vd-color-picker>
    <div id="color" class="input-group colorpicker-component fg-color">
        <input type="text" name="{opts.name}" value="{opts.riotValue}" class="form-control" onChange={change}/>
        <span class="input-group-label"><i style="min-width: 17px; min-height: 17px;"></i></span>
    </div>
    <script>
        var d = new Date();
        this.previewColorChange = d.getTime();

        change(e){
            this.opts.evchange(e)
        }

        this.on('mount', function(){
            $('.colorpicker-component', this.root).colorpicker().on('change', function(e) {
                var d = new Date();
                var currentTime = d.getTime();
                if(currentTime - this.previewColorChange > 500){
                    var event = new Event('change');
                    $('input', this.root)[0].dispatchEvent(event);

                    var d = new Date();
                    this.previewColorChange = d.getTime();
                }
            }.bind(this))
        })
    </script>
</vd-color-picker>

<vd-font-picker>
    <select name="{opts.name}" class="form-control"></select>
    <script>
        var y = 0;

        this.on('mount', function(){

            $('select', this.root).select2({
                data: $.fontset,
                placeholder: "Select Font Family",
                triggerChange: true,
                allowClear: true,
                theme: "bootstrap",
                minimumResultsForSearch: Infinity,
                templateResult: function (result) {
                    var state = $('<div style="background-position:-10px -' + y + 'px !important;" class="li_' + result.itemId + '">' + result.text + '</div>');
                    y += 29;
                    return state;
                }
            });
            $('select', this.root).val(this.opts.riotValue).trigger('change');

            $('select', this.root).on("select2:open", function () {
                y = 0;
            });
            $('select', this.root).on("select2:close", function () {
                y = 0;
            });
            var that = this
            $('select', this.root).on('change', function(e) {
                that.opts.evchange(e)
            })
        })
</script>
</vd-font-picker>
<vd-icon-picker>
    <div class="input-group vd-icon-group-control">
        <div class="input-group-text"><i class="{opts.riotValue}"></i></div>
        <input type="text" class="form-control" name="{opts.name}" value="{opts.riotValue}" oninput={inputFilter} onChange={changeFilter}>
        <div class="input-group-btn">
            <button type="button" onclick={clickCollapse} class="btn-collapse btn btn-light">
                <i class="far fa-angle-down" if="{!open}"></i>
                <i class="far fa-angle-up" if="{open}"></i>
            </button>
        </div>
    </div>
    <div class="vd-icon-picker-wrapper" if={open}>
        <virtual each={icon in icons}>
            <div class="vd-icon-element {opts.riotValue == icon?  'active': ''}" onclick={clickIcon}>
                <span  class="{icon}"></span>
            </div>
        </virtual>
    </div>
    <script>
        this.library = this.opts.library
        this.icons = window.iconset[this.opts.library]
        this.open = false
        this.loading = false
        this.filter = ''
        clickCollapse(e) {
            this.open = !this.open
        }
        clickIcon(e){
            var event = {}
            event.currentTarget = event.target = {name: this.opts.name, value: e.item.icon}
            this.opts.evchange(event)
        }.bind(this)
        this.on('update', function(e){
            if(this.library !== this.opts.library) {
                this.library = this.opts.library
                this.icons = window.iconset[this.opts.library]
            }
        })
        inputFilter(e) {
            if(e.currentTarget.value != ''){
                this.icons =_.filter(window.iconset[this.opts.library], function(value){
                    return value.indexOf(e.currentTarget.value) != -1
                }.bind(this))
            } else {
                this.icons = window.iconset[this.opts.library]
            }
        }
        changeFilter(e) {
            this.opts.evchange(e)
        }
    </script>
</vd-icon-picker>

<vd-image>
    <a href="" id="thumb-vd-image" data-toggle="vd-image" class="img-thumbnail">
        <img src="{opts.thumb}" alt="" title="" width="100px" height="100px" data-placeholder="{!_.isUndefined(opts.placeholder) ? opts.placeholder : store.getOptions('designer.placeholder')}"/>
    </a>
    <input type="hidden" name="{opts.name}" value="{opts.value}" id="input-vd-image"  onChange={change}/>
    <script>
        this.mixin({store: d_visual_designer})
        change(e) {
            this.opts.evchange(e)
        }
    </script>
</vd-image>

<vd-input-group>
    <div class="wrap-setting-wrapper">
        <div class=wrap-setting>
            <input type="text" name="{params.name}_top" class="form-control pixels-procent" value="{setting.global[params.name+'_top']}" onChange={change}>
            <span class="label-helper">{store.getLocal('designer.text_top')}</span>
        </div>
        <div class="wrap-setting">
            <input type="text" name="{params.name}_right" class="form-control pixels-procent" value="{setting.global[params.name+'_right']}" onChange={change}>
            <span class="label-helper">{store.getLocal('designer.text_right')}</span>
        </div>
        <div class="wrap-setting">
            <input type="text" name="{params.name}_bottom" class="form-control pixels-procent" value="{setting.global[params.name+'_bottom']}" onChange={change}>
            <span class="label-helper">{store.getLocal('designer.text_bottom')}</span>
        </div>
        <div class="wrap-setting">
            <input type="text" name="{params.name}_left" class="form-control pixels-procent" value="{setting.global[params.name+'_left']}" onChange={change}>
            <span class="label-helper">{store.getLocal('designer.text_left')}</span>
        </div>
    </div>
    <script>
        this.mixin({store:d_visual_designer})
        this.params = !_.isUndefined(opts.params)? opts.params : opts

        this.setting = this.store.getState().blocks[this.params.designer_id][this.params.block_id].setting

        change(e) {
            this.setting.global[e.target.name] = e.target.value
            this.store.dispatch('block/setting/fastUpdate', {designer_id: this.params.designer_id, block_id: this.params.block_id, setting: this.setting})
        }.bind(this)

        this.on('update', function () {
            this.params = !_.isUndefined(opts.params)? opts.params : opts

            this.setting = this.store.getState().blocks[this.params.designer_id][this.params.block_id].setting
        })
    </script>
</vd-input-group>
<vd-radio-btn-group>
    <div class="btn-group vd-radio-btn-group" data-bs-toggle="buttons">
        <label each={value, key in opts.options} class="btn btn-success {parent.opts.riotValue == key?'active':''}" onClick={changeRadioGroup}>
            <input type="radio" name="{opts.name}" value="{key}" checked={parent.opts.riotValue == key} onChange={change}>{value}
        </label>
    </div>
    <script>
        change(e) {
            this.opts.evchange(e)
        }
        changeRadioGroup(e){
			const target = {target: {
                name: this.opts.name,
                value: e.target.childNodes[1] ? e.target.childNodes[1].value : e.target.value
            }};
            this.opts.evchange(target);
        }
    </script>
</vd-radio-btn-group>

<vd-range>
    <div class="range">
        <input type="range" step="{step}" min="{min}" max="{max}" name="{opts.name}_range" value="{rangeValue}" disabled={opts.riotValue == ''} onChange={changeRange} onInput={changeRange}>
        <input type="text" class="form-control" name="{opts.name}" value="{getFullText()}" onchange={change}/>
    </div>
    <script>
        var d = new Date();
        this.rangeValue = this.opts.riotValue
        this.step = this.opts.step
        this.max = this.opts.max
        this.min = this.opts.min
        this.previewRangeChange = d.getTime();

        this.getFullText = function(){
            var er = /^-?[0-9]+$/;
            if(er.test(this.opts.riotValue)){
                return this.opts.riotValue+'px'
            }
            return this.opts.riotValue
        }
        
        this.initValue = function() {
          var rangeValue = this.opts.riotValue
          rangeValue = rangeValue.replace('px', '').replace('rem', '').replace('em', '')
          this.rangeValue = rangeValue
        }
        
        this.initStep = function() {
          var step = this.opts.step
          var remTest = /^-?[0-9.,]+(rem)$/
          var emTest = /^-?[0-9]+(em)$/
          var pxTest = /^-?[0-9]+(px)$/
          if(!this.opts.step) {
            if(remTest.test(this.opts.riotValue)){
              step = 0.1
            }
            if(emTest.test(this.opts.riotValue)){
              step = 0.1
            }
            if(pxTest.test(this.opts.riotValue)){
              step = 1
            }
          }
          this.step = step
        }
        this.initMax = function() {
          var max = this.opts.max
          var remTest = /^-?[0-9.,]+(rem)$/
          var emTest = /^-?[0-9.,]+(em)$/
          var pxTest = /^-?[0-9]+(px)$/
          if(!this.opts.max) {
            if(remTest.test(this.opts.riotValue)){
              max = 10
            }
            if(emTest.test(this.opts.riotValue)){
              max = 10
            }
            if(pxTest.test(this.opts.riotValue)){
              max = 100
            }
          }
          this.max = max
        }
        this.initMin = function() {
          var min = this.opts.min
          var remTest = /^-?[0-9.,]+(rem)$/
          var emTest = /^-?[0-9.,]+(em)$/
          var pxTest = /^-?[0-9]+(px)$/
          if(!this.opts.min) {
            if(remTest.test(this.opts.riotValue)){
              min = 0.1
            }
            if(emTest.test(this.opts.riotValue)){
              min = 0.1
            }
            if(pxTest.test(this.opts.riotValue)){
              min = 1
            }
          }
          this.min = min
        }

        changeRange(e) {
            var d = new Date();
            var currentTime = d.getTime();
            if(currentTime - this.previewRangeChange > 100){
              var remTest = /^-?[0-9.,]+(rem)$/
              var emTest = /^-?[0-9.,]+(em)$/
              var pxTest = /^-?[0-9]+(px)$/
              var numberTest = /^-?[0-9.,]+$/
              var newValue = e.target.value
              if(remTest.test(this.opts.riotValue)){
                newValue +='rem'
              }
              if(emTest.test(this.opts.riotValue)){
                newValue +='em'
              }
              if(pxTest.test(this.opts.riotValue)){
                newValue +='px'
              }
              if(numberTest.test(this.opts.riotValue)){
                newValue +='px'
              }
              this.opts.evchange({target:{
                    name: opts.name,
                    value: newValue
                }});

                var d = new Date();
                this.previewRangeChange = d.getTime();
            }
        }.bind(this)
        
        this.initValue()
        this.initStep()
        this.initMax()
        this.initMin()
        
        this.on('update', function(){
          this.initValue()
          this.initStep()
          this.initMax()
          this.initMin()
        })

        change(e) {
            this.opts.evchange(e);
        }.bind(this)
    </script>
</vd-range>
<vd-select-icon-library>
    <select class="form-select" name="{opts.name}" onChange={change}>
        <option each={value, key in store.getOptions('designer.libraries')} value="{key}" selected={key == opts.riotValue}>{value}</option>
    </select>
    <script>
        this.mixin({store:d_visual_designer})
        change(e) {
            if(e.target.value !== this.opts.riotValue) {
                this.opts.evchange(e)
            }
        }
    </script>
</vd-select-icon-library>

<vd-switcher>
    <input type="hidden" name="{opts.name}" value="0" />
    <input type="checkbox" name="{opts.name}" class="switcher" data-label-text="{opts.label ? opts.label : store.getLocal('designer.text_enabled')}" checked={opts.riotValue} value="1"/>
    <script>
        this.mixin({store:d_visual_designer})
        this.on('mount', function(){
            $(".switcher[type='checkbox']", this.root).bootstrapSwitch({
                'onColor': 'success',
                'onText': this.store.getLocal('designer.text_yes'),
                'offText': this.store.getLocal('designer.text_no')
            });
            $(".switcher[type='checkbox']", this.root).on('switchChange.bootstrapSwitch', function(e, state) {
                this.opts.evchange({target: {name: e.target.name, value: state}})
            }.bind(this));
        })
    </script>
</vd-switcher>
<vd-tab-nav>
    <div class="vd-style-tab">
        <div each="{tab in opts.tabs}" class="vd-style-tab-item {tab.type == active? 'active' : ''}" data-type="{tab.type}" onclick="{click}">{tab.name}</div>
    </div>
    <div class="vd-style-tab-content">
        <virtual each="{tab in opts.tabs}">
            <div class="vd-style-tab-item {tab.type == active ? 'active' : ''}">
                <div data-is="{tab.is}" params="{tab.opts}"/>
            </div>
        </virtual>

    </div>
    <script>
        this.active = _.first(opts.tabs).type

        click(e)
        {
            this.active = $(e.currentTarget).data('type')
            this.update()
        }
    </script>
</vd-tab-nav>
