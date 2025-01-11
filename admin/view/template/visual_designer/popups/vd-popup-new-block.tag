<vd-popup-new-block>
<div class="vd vd-popup-overlay" if={this.status}></div>
<div class="vd vd-popup add_block" if={this.status}>
    <div class="popup-header">
        <h2 class="title"><formatted-message path='designer.text_add_block'/></h2>
        <div class="search">
            <i class="fa fa-search" aria-hidden="true"></i>
            <input type="text" name="search" placeholder="{this.store.getLocal('designer.text_search')}" onInput={searchBlock} value="{search}"/>
        </div>
        <a class="close" onClick={close}><i class="fal fa-times"></i></a>
    </div>
    <div class="popup-tabs">
        <ul class="vd-nav nav nav-tabs">
            <li><a class="active" href="#tab-get-template" data-bs-toggle="tab" onClick={categoryReset}><formatted-message path='designer.tab_all_blocks'/></a></li>
            <li each={category in categories}><a id="new-block-tab"  data-bs-toggle="tab" onClick={categoryChange}>{category}</a></li>
        </ul>
    </div>
    <div class="popup-content">
        <div class="notify alert alert-warning" if={store.getState().config.notify}>
            <formatted-message path='designer.text_complete_version'/>
        </div>
        <div class="row popup-new-block">
            <div class="col-md-3 col-sm-6 col-xs-12 element" each={block in blocks}>
                <div class="block" onClick={addBlock}>
                    <a id="add_block" name="type">
                        <span><img src="{block.image}" class="image"></span>
                        {block.title}
                        <i class="description">
                           {block.description}
                        </i>
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

    this.store.subscribe('popup/addBlock', function(data){
        if(data.designer_id == this.parent.top.opts.id){
            this.status = true
            this.level = data.level
            this.parent_id = data.parent_id
            this.update()
            this.initPopup()
        }
    }.bind(this))
    this.store.subscribe('block/create/success', function(){
        this.status = false
    }.bind(this))
    addBlock(e) {
        this.store.dispatch('block/new', {type: e.item.block.type, designer_id:this.parent.top.opts.id, target: this.parent_id, level: this.level})
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
        this.blocks = []
        this.categories = []
        var items = this.store.getState().config.blocks

        this.blocks = _.pick(items, function(item){
             if(item.setting.level_min <= this.level && item.setting.level_max >= this.level) {
                 return true
             }
             if(this.level == 0 && item.setting.level_min == 3 && (item.setting.helper_insert || _.isUndefined(item.setting.helper_insert))){
                 return true
             }
             return false
        }.bind(this))
        for(var key in this.blocks) {
            if(this.categories.indexOf(this.blocks[key].category) == -1) {
                this.categories.push(this.blocks[key].category)
            }
        }
        if(this.category != '*') {
            this.blocks = _.pick(this.blocks, function(item){
                return item.category === this.category
            }.bind(this))
        }
        if(this.search != '') {
            this.blocks = _.pick(this.blocks, function(item){
                return item.title.toLowerCase().indexOf(this.search.toLowerCase()) != -1
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
</vd-popup-new-block>
