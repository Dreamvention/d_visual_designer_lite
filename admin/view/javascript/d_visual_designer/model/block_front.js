(function(){
    /**
     * Full update block setting with Ajax Request
     */
    this.subscribe('block/setting/update', function(data){
        this.updateSetting(data)
    })

    this.updateSetting = function(data) {
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
                    if(!_.isUndefined(data.callback)) {
                        data.callback()
                    }
                }
            },
            complete: function() {
                this.dispatch('block/setting/update/end', {designer_id: data.designer_id})
            }
        })
    }


    /**
     * Update setting without Ajax request
     */

    this.subscribe('block/setting/fastUpdate', function(data){
        var blocks = this.getState().blocks
        blocks[data.designer_id][data.block_id].setting = _.extend({}, data.setting)
        this.updateState({blocks: blocks})
        this.dispatch('history/backup', {block_id: data.block_id, designer_id: data.designer_id, fast: true})
    })


    this.subscribe('block/layout/update', function(data){
        var block_config = _.find(this.getState().config.blocks, function(block){
            return block.type == data.type
        })
        var result = {
            new: [],
            update: [],
            delete: []
        }
        var indexSize = 0
        var blocks = this.getState().blocks
        var childBlocks = this.getBlocks(data.designer_id, data.block_id)
        if(_.size(data.size) >= _.size(childBlocks)){
            for (var key in childBlocks) {
                blocks[data.designer_id][childBlocks[key].id].setting.global.size=data.size[indexSize]
                result.update.push(childBlocks[key].id)
                indexSize++;
            }
        }

        if(_.size(data.size) < _.size(childBlocks)){
            for (var key in childBlocks) {
                if(indexSize < _.size(data.size)){
                    blocks[data.designer_id][childBlocks[key].id].setting.global.size=data.size[indexSize]
                    result.update.push(childBlocks[key].id)

                } else {
                    result.delete.push(childBlocks[key].id)
                    delete blocks[data.designer_id][childBlocks[key].id];
                }
                indexSize++;
            }
        }

        this.updateState({blocks: blocks})

        if(_.size(data.size) > _.size(childBlocks)){
            for(var i=indexSize; i< _.size(data.size); i++){
                var block_id = this.newBlock(data.designer_id, block_config.setting.child, data.block_id, {size:data.size[i]});
                result.new.push(block_id)
            }
        }

        this.dispatch('block/layout/update/success', {result: result, designer_id: data.designer_id})
    })
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
