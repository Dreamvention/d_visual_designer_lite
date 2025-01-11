(function(){
    this.subscribe('block/new', function(data) {
        var block_config = _.find(this.getState().config.blocks, function(block){
            return block.type == data.type
        })
        var blocks = {}
        if(block_config.setting.level_min == 3 && data.level == 0){
            var section_wrapper_id = this.newBlock(data.designer_id, 'section_wrapper', '');
            var row_id = this.newBlock(data.designer_id, 'row', section_wrapper_id);
            var column_id = this.newBlock(data.designer_id, 'column', row_id);
            data.target = column_id
        }
        var new_block_id = this.newBlock(data.designer_id, data.type, data.target)
        if(block_config.setting.child) {
            var new_child_block_id = this.newBlock(data.designer_id, block_config.setting.child, new_block_id);
            var block_child_config = _.find(this.getState().config.blocks, function(block){
                return block.type == block_config.setting.child
            })
            if(block_child_config.setting.child) {
                this.newBlock(data.designer_id, block_child_config.setting.child, new_child_block_id);
            }
        }
        this.dispatch('block/create/success', {block_id: new_block_id, type: data.type, designer_id: data.designer_id})
    }.bind(this));
    this.subscribe('block/remove', function(data) {

        var block_config = _.find(this.getState().config.blocks, function(block){
            return block.type == data.type
        })

        var blocks = this.getState().blocks

        var parent = blocks[data.designer_id][data.block_id].parent

        if(parent != ''){
            var block_config_parent = _.find(this.getState().config.blocks, function(block){
                return block.type == blocks[data.designer_id][parent].type
            })

            var childBlocks = this.getBlocks(data.designer_id, parent)

            if (block_config_parent.setting.child && _.size(childBlocks) == 1){
                data.block_id = parent
            }
        }

        this.removeBlock(data.designer_id, data.block_id)

        this.dispatch('block/remove/success')
        $('body').trigger('remove_block_success', {'title': block_config.title});
    }.bind(this));

    this.removeBlock = function(designer_id, block_id) {

        var blocks = this.getState().blocks

        blocks[designer_id] = _.pick(blocks[designer_id], function(value, key, object){
            return block_id != value.id
        })

        this.updateState({blocks: blocks})

        var childBlocks = this.getBlocks(designer_id, block_id)
        if(_.size(childBlocks) > 0) {
            for(var key in childBlocks){
                this.removeBlock(designer_id, childBlocks[key].id)
            }
        }
    }

    this.subscribe('block/move/start', function(data) {
        var blocks = JSON.parse(JSON.stringify(this.getState().blocks))
        blocks[data.designer_id][data.block_id].parent = null
        this.updateState({blocks: blocks})
    })

    this.subscribe('block/move', function(data){
        var block_info = this.getState().blocks[data.designer_id][data.block_id]
        if(block_info.parent != data.target) {
            var childBlocks = this.getBlocks(data.designer_id, data.target)
            var blocks = JSON.parse(JSON.stringify(this.getState().blocks))
            for(var key in childBlocks) {
                if(blocks[data.designer_id][childBlocks[key].id].sort_order >= data.sort_order)
                {
                    blocks[data.designer_id][childBlocks[key].id].sort_order += 1
                }
            }

            blocks[data.designer_id][data.block_id].parent = data.target
            blocks[data.designer_id][data.block_id].sort_order = data.sort_order
            this.updateState({blocks: blocks})

            if(data.start_under_id != ''){
                var block_config_parent = _.find(this.getState().config.blocks, function(block){
                    return block.type == blocks[data.designer_id][data.start_under_id].type
                })

                var childBlocks = this.getBlocks(data.designer_id, data.start_under_id)

                if (block_config_parent.setting.child && _.size(childBlocks) == 0){
                    data.block_id = data.start_under_id
                    this.removeBlock(data.designer_id, data.block_id)
                }
            }

        }
        if(data.success){
            data.success()
        }
        this.dispatch('block/move/success')
    })
    this.subscribe('block/layout/update', function(data){
        var block_config = _.find(this.getState().config.blocks, function(block){
            return block.type == data.type
        })
        var indexSize = 0
        var blocks = this.getState().blocks
        var childBlocks = this.getBlocks(data.designer_id, data.block_id)
        if(_.size(data.size) >= _.size(childBlocks)){
            for (var key in childBlocks) {
                blocks[data.designer_id][childBlocks[key].id].setting.global.size=data.size[indexSize]
                indexSize++;
            }
        }

        if(_.size(data.size) < _.size(childBlocks)){
            for (var key in childBlocks) {
                if(indexSize < _.size(data.size)){
                    blocks[data.designer_id][childBlocks[key].id].setting.global.size=data.size[indexSize]

                } else {
                    delete blocks[data.designer_id][childBlocks[key].id];
                }
                indexSize++;
            }
        }

        this.updateState({blocks: blocks})

        if(_.size(data.size) > _.size(childBlocks)){
            for(var i=indexSize; i< _.size(data.size); i++){
                this.newBlock(data.designer_id, block_config.setting.child, data.block_id, {size:data.size[i]});
            }
        }

        this.dispatch('block/layout/update/success')
    })
    /**
     * Full update block setting with Ajax Request
     */
    this.subscribe('block/setting/update', function(data){
        var block_info = this.getState().blocks[data.designer_id][data.block_id]
        var send_data = {
            setting: JSON.stringify(block_info.setting),
            type:block_info.type
        }
        var blocks = this.getState().blocks

        $.ajax({
            url: 'index.php?route=extension/visual_designer/visual_designer/designer|updateSetting&'+this.getState().config.url_token,
            type: 'post',
            dataType: 'json',
            data: send_data,
            context: this,
            success: function(json) {
                if(json['success']){
                    this.dispatch('block/setting/update/begin')
                    var blocks = this.getState().blocks

                    blocks[data.designer_id][data.block_id].setting = _.extend({}, json.setting)
                    this.updateState({blocks: blocks})
                    this.dispatch('history/backup', {block_id: data.block_id, designer_id: data.designer_id, fast: false})
                }
            },
            complete: function() {
                this.dispatch('block/setting/update/end', {designer_id: data.designer_id})
            }
        })
    })

    /**
     * Update setting without Ajax request
     */

    this.subscribe('block/setting/fastUpdate', function(data){
        var blocks = this.getState().blocks
        blocks[data.designer_id][data.block_id].setting = _.extend({}, data.setting)
        this.updateState({blocks: blocks})
        this.dispatch('history/backup', {block_id: data.block_id, designer_id: data.designer_id, fast: true})
    })
    /**
     * Clone target block
     */
    this.subscribe('block/clone', function(data){
        var block_info = this.getState().blocks[data.designer_id][data.target]
        var block_config = _.find(this.getState().config.blocks, function(block){
            return block.type == block_info.type
        })
        var block_id = this.newBlock(data.designer_id, block_info.type, block_info.parent, block_info.setting.global, block_info.setting.user, block_info.setting.edit)
        this.cloneBlocks(data.designer_id, block_info.id, block_id)
        this.dispatch('block/clone/success')
    })

    /**
     * Update param sort_order in child blocks for selected block
     */
    this.updateSortOrder = function(designer_id, block_id){
        var blocks = JSON.parse(JSON.stringify(this.getState().blocks))
        if(!_.isEmpty(block_id)){
            var container =$('#'+designer_id).find('[id='+block_id+']').children('.block-content')
        } else {
            var container = $('#'+designer_id).find('#sortable')
        }

        for (var i = 0; i < container.get(0).children.length; i++) {
            if(container.get(0).children[i].classList.contains('block-container')) {
                var index = container.get(0).children[i].id
                blocks[designer_id][index].sort_order = i
            }
        }

        this.updateState({blocks: blocks})
    }

    /**
     * Clone blocks by parent_id
     */
    this.cloneBlocks = function(designer_id, parent_id, new_parent_id){
        var blocks = this.getBlocks(designer_id, parent_id)
        if(_.size(blocks)){
            for (var key in blocks){
                var block_id = this.newBlock(designer_id, blocks[key].type, new_parent_id, blocks[key].setting.global, blocks[key].setting.user, blocks[key].setting.edit)
                this.cloneBlocks(designer_id, blocks[key].id, block_id)
            }
        }
    }

    /**
     * Create new Block
     */
    this.newBlock = function(designer_id, type, target, default_setting, user_setting, edit_setting){
        var default_setting = _.isUndefined(default_setting) ? null : default_setting
        var user_setting = _.isUndefined(user_setting) ? null : user_setting
        var edit_setting = _.isUndefined(edit_setting) ? null : edit_setting

        var block_config = _.find(this.getState().config.blocks, function(block){
            return block.type == type
        })
        var childBlocks = this.getBlocks(designer_id, target)
        if(!_.isEmpty(childBlocks)){
            var lastBlock = _.max(childBlocks, function(value){
                return value.sort_order
            })
        } else{
            var lastBlock = {}
        }

        var blocks = this.getState().blocks
        var block_id = type+'_'+Math.random().toString(36).substring(2, 9)
        blocks[designer_id][block_id] = {
            setting: JSON.parse(JSON.stringify(block_config.setting_default)),
            parent: target,
            id: block_id,
            type: type,
            sort_order: !_.isEmpty(lastBlock)? lastBlock.sort_order + 1 : 0
        }
        if(!_.isNull(default_setting)){
            blocks[designer_id][block_id].setting.global = _.extend({}, blocks[designer_id][block_id].setting.global, default_setting)
        }
        if(!_.isNull(edit_setting)){
            blocks[designer_id][block_id].setting.edit = _.extend({}, blocks[designer_id][block_id].setting.edit, edit_setting)
        }
        if(!_.isNull(user_setting)){
            blocks[designer_id][block_id].setting.user = _.extend({}, blocks[designer_id][block_id].setting.user, user_setting)
        }
        this.updateState({blocks: blocks})
        if(_.isNull(user_setting) || _.isNull(edit_setting)) {
            this.dispatch('block/setting/update', {designer_id, block_id})
        }
        return block_id
    }
}.bind(d_visual_designer))()
