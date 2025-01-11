<vd-popup-load-template>
<div class="vd vd-popup-overlay" if={this.status}></div>
<div class="vd vd-popup add_template" if={this.status}>
    <div class="popup-header">
        <h2 class="title"><formatted-message path='designer.text_add_template'/></h2>
        <div class="search">
            <i class="fa fa-search" aria-hidden="true"></i>
            <input type="text" name="search" placeholder="{this.store.getLocal('designer.text_search')}" onInput={searchBlock} value="{search}"/>
        </div>
        <a class="close" onClick={close}><i class="fal fa-times"></i></a>
    </div>
    <div class="popup-tabs">
        <ul class="vd-nav">
            <li class="active"><a href="#tab-get-template" data-bs-toggle="tab" onClick={categoryReset}><formatted-message path='designer.tab_all_blocks'/></a></li>
            <li each={category in categories}><a id="new-block-tab"  data-bs-toggle="tab" onClick={categoryChange}>{category}</a></li>
        </ul>
    </div>
    <div class="popup-content">
        <div class="notify alert alert-warning" if={store.getState().config.notify}>
            <formatted-message path='designer.text_complete_version'/>
        </div>
        <div class="popup-new-template">
            <div class="element" each={template in templates}>
                <div class="template" onClick={addTemplate}>
                    <a id="add_block" name="type">
                        <img src="{template.image}" class="image">
                        <p class="title">{template.name}</p>
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    this.mixin({store:d_visual_designer})
    this.status = false
    this.search = ''
    this.category = '*'
    this.level = 0
    this.target = ''
    this.width = ''
    this.height = ''
    this.left = ''
    this.top = ''

    this.store.subscribe('template/list', function(data){
        if(data.designer_id == this.parent.top.opts.id){
            this.status = true
            this.level = data.level
            this.parent_id = data.parent_id
            this.update()
            this.initPopup()
        }
    }.bind(this))
    this.store.subscribe('template/load/success', function(){
        this.status = false
        this.update()
    }.bind(this))
    addTemplate(e) {
        this.store.dispatch('template/load', {config: e.item.template.config, designer_id:this.parent.top.opts.id, template_id: e.item.template.template_id})
    }
    this.initPopup = function() {
        $('.vd-popup', this.root).resizable({
            start: function(){
                $('body').addClass('vd-resizable')
            },
            resize: function(event, ui) {
                if(!$('.vd-popup', this.root).hasClass('drag')){
                    $('.vd-popup', this.root).addClass('drag')
                }

                $('.vd-popup', this.root).css({ 'max-height': '' });
            }.bind(this),
            stop: function( event, ui ) {
                this.width = ui.size.width;
                this.height = ui.size.height;
                $('body').removeClass('vd-resizable')
            }.bind(this)
        });
        $('.vd-popup', this.root).draggable({
            handle: '.popup-header',
            drag: function(event, ui) {
                if (!ui.helper.hasClass('drag')) {
                    ui.helper.addClass('drag');
                }
            },
            stop: function(event, ui) {
                if (ui.position.top < 0) {
                    ui.helper.css({ 'top': '10px' });
                }
                var height = $(window).height();
                if ((ui.position.top + 100) > height) {
                    ui.helper.css({ 'top': (height - 100) + 'px' });
                }
                this.left = ui.position.left
                this.top = ui.position.top
            }.bind(this)
        });
        if (this.left != '' && this.top != '') {
            $('.vd-popup', this.root).addClass('drag');
            $('.vd-popup', this.root).css({ 'left': this.left, 'top': this.top });
        }
        if (this.width != '' && this.height != '') {
            $('.vd-popup', this.root).css({ 'width': this.width, 'height': this.height });
        }
        $('.vd-popup', this.root).css({ visibility: 'visible', opacity: 1 });

    }.bind(this)

    this.on('update', function(){
        this.templates = []
        this.categories = []
        this.templates = this.store.getState().templates

        for(var key in this.templates) {
            if(this.categories.indexOf(this.templates[key].category) == -1) {
                this.categories.push(this.templates[key].category)
            }
        }
        if(this.category != '*') {
            this.templates = _.pick(this.templates, function(template){
                return template.category === this.category
            }.bind(this))
        }
        if(this.search != '') {
            this.templates = _.pick(this.templates, function(template){
                return template.name.toLowerCase().indexOf(this.search.toLowerCase()) != -1
            }.bind(this))
        }
    })

    categoryChange(e) {
        this.category = e.item.category
    }

    categoryReset(e) {
        this.category = '*'
    }

    searchBlock(e) {
        this.search = e.target.value
    }

    close() {
        this.status = false
    }
</script>
</vd-popup-load-template>
