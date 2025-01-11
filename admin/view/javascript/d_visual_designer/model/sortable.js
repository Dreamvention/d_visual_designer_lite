function vd_sortable(options) {

    this.under_id = '';
    this.drag_id = '';
    this.drag_type = '';
    this.start_under_id = '';
    this.dragging = false;
    this.itemsHorizontal = false;
    this.allowZones = null;
    this.sortableItems = {};
    this.store = d_visual_designer;

    var defaults = {
        designer_id: ''
    }

    for (var name in defaults) {
        !(name in options) && (options[name] = defaults[name]);
    }

    if (!$(".helper-sortable").length) {
        $('body').append('<div class="helper-sortable" style="display:none;"></div>')
    }

    $('body').mousemove(function (event) {
        if(this.dragging) {
            $('.helper-sortable').css({
                left: event.pageX,
                top: event.pageY
            });
        }
    }.bind(this));

    /**
    * Init Sortable for new tag
    **/
    this.store.subscribe('sortable/init', function(data){
        if(options.designer_id == data.designer_id) {
            if(data.block_id != ''){
                var block_info = this.store.getState().blocks[data.designer_id][data.block_id]
                var block_config = _.find(this.store.getState().config.blocks, function(block){
                    return block.type == block_info.type
                })
                if(!block_config.setting.child && block_config.setting.child_blocks) {
                    if (!this.sortableItems.all) {
                        this.sortableItems.all = {}
                    }
                    if(!this.sortableItems.all[block_info.id]){
                        this.sortableItems.all[block_info.id] = {
                            id: block_info.id,
                            block_config: block_config
                        }
                    }
                }
                if(block_config.setting.child && block_config.setting.child_blocks){
                    var child_type = block_config.setting.child
                    if (!this.sortableItems[child_type]) {
                        this.sortableItems[child_type] = {}
                    }
                    if(!this.sortableItems[child_type][block_info.id]){
                        this.sortableItems[child_type][block_info.id] = {
                            id: block_info.id,
                            block_config: block_config
                        }
                    }
                }
            } else {
                if (!this.sortableItems['row']) {
                    this.sortableItems['row'] = {
                        '': {
                            id: ''
                        }
                    }
                }
            }
        }
    }.bind(this))

    /**
    * Start new drag and drog
    **/
    this.store.subscribe('block/drag/start', function (data) {
        if(data.designer_id === options.designer_id) {
            var block_config = _.find(this.store.getState().config.blocks, function (block) {
                return block.type == data.type
            })
            var block_info = this.store.getState().blocks[data.designer_id][data.block_id]
            $('.helper-sortable').html('<img class="icon" src="' + block_config.image + '" width="32px" height="32px"/>' + block_config.title)
            $('.helper-sortable').show()

            var drag = this.store.getState().drag

            drag[data.designer_id] = true
            this.drag_id = data.block_id

            this.under_id = block_info.parent
            this.start_under_id = block_info.parent
            this.start_sort_order = block_info.sort_order
            this.drag_type = data.type
            this.dragging = true

            if (this.sortableItems[this.drag_type]) {
                this.allowZones = this.sortableItems[this.drag_type]
                this.itemsHorizontal = false
            } else {
                this.allowZones = this.sortableItems.all
                this.itemsHorizontal = false
            }

            for (var key in this.allowZones) {
                var blockId = this.allowZones[key].id
                if (key != '') {
                    var container = $('.block-container[id="' + blockId + '"]')
                } else {
                    var container = $('[id=sortable][data-vd_id="' + options.designer_id + '"][id="' + blockId + '"]')
                }
                container.on("mouseenter", function (event) {
                    if (this.dragging) {
                        var underId = $(event.currentTarget).attr('id')

                        this.store.dispatch('block/placeholder/show', {
                            designer_id: options.designer_id,
                            block_id: underId
                        })
                        this.under_id = underId
                    }
                }.bind(this));
                container.on("mouseleave", function (event) {
                    if (this.dragging) {
                        var underId = $(event.currentTarget).attr('id')

                        this.store.dispatch('block/placeholder/hide', {
                            designer_id: options.designer_id,
                            block_id: underId
                        })
                        this.under_id = this.start_under_id
                    }
                }.bind(this));
            }

            this.store.dispatch('block/move/start', {designer_id: options.designer_id, block_id: this.drag_id})
            this.store.dispatch('block/placeholder/show', {designer_id: options.designer_id, block_id: this.under_id})
            this.store.updateState({drag: drag})
        }

    }.bind(this))

    $('body').on('mouseup', function(){
        if(this.dragging){
            this.store.dispatch('sortable/end', {designer_id: options.designer_id, block_id: this.start_under_id, sort_order: this.start_sort_order})
        }
    }.bind(this))

    /**
    * End Drag and Drop
    **/
    this.store.subscribe('sortable/end', function(data){
        if(data.designer_id === options.designer_id) {
            $('.helper-sortable').hide()
            for (var key in this.allowZones) {
                var blockId = this.allowZones[key].id
                if (key != '') {
                    var container = $('.block-container[id="' + blockId + '"]')
                } else {
                    var container = $('[id=sortable][data-vd_id="' + options.designer_id + '"][id="' + blockId + '"]')
                }
                container.off("mouseenter");
                container.off("mouseleave");
            }
            this.allowZones = null
            this.dragging = false
            this.store.dispatch('block/placeholder/hide', {designer_id: options.designer_id, block_id: this.under_id})
            this.store.dispatch('block/move', {
                block_id: this.drag_id,
                target: this.under_id,
                start_under_id: this.start_under_id,
                designer_id: options.designer_id,
                sort_order: data.sort_order,
                success: function () {
                    var drag = this.store.getState().drag
                    drag[options.designer_id] = false
                    this.store.updateState({drag: drag})
                }.bind(this)
            })
            this.start_under_id = '';
        }
    }.bind(this))
}
