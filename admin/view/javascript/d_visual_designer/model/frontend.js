(function(){
    this.initExternalDesigner = function(d_visual_designer) {
        this.external_vd = d_visual_designer
    }

    this.subscribe('designer/external/init', function(data) {
        this.external_vd = data.external_vd

        this.externalEvents()

        var blocks = JSON.parse(JSON.stringify(this.getStateExternal().blocks))

        for(var designer_id in blocks){
            this.dispatch('content/designer/init', {designer_id: designer_id})
            this.updateBlocks(designer_id, blocks[designer_id])
        }
        
        riot.update()
    })

    this.externalEvents = function(){
        this.external_vd.subscribe('popup/addBlock', function(data) { this.dispatch('popup/addBlock', data) }.bind(this)) 

        this.external_vd.subscribe('block/layout/begin', function(data) { this.dispatch('block/layout/begin', data) }.bind(this)) 

        this.external_vd.subscribe('block/setting/begin', function(data) { 
            this.dispatch('block/setting/begin', data) 
        }.bind(this)) 
        this.external_vd.subscribe('template/list', function(data) { 
            if(!_.isUndefined(data.empty)){
                this.dispatch('template/list', data) 
            }
        }.bind(this)) 

        this.external_vd.subscribe('save_content_success', function() {
            this.alert_handler(this.getLocal('designer.text_success_update'), 'success')
            this.dispatch('save_content_success')
        }.bind(this))

        this.external_vd.subscribe('save_content_permission', function() {
            this.alert_handler(this.getLocal('designer.error_permission'), 'error')
            this.dispatch('save_content_permission')
        }.bind(this))

        this.external_vd.subscribe('block/clone/complete', function(data) { 
            var block_info = this.getStateExternal().blocks[data.designer_id][data.block_id]
            var block_config = _.find(this.getState().config.blocks, function(block){
                return block.type == block_info.type
            })
            var blocks = this.getState().blocks
            blocks[data.designer_id][data.block_id] = JSON.parse(JSON.stringify(block_info))
            blocks[data.designer_id][data.block_id].setting.edit = block_config.setting_default.edit
            this.updateState({blocks: blocks})
        }.bind(this)) 
        this.external_vd.subscribe('block/create/success', function(data) { 
            var block_info = this.getStateExternal().blocks[data.designer_id][data.block_id]
            var block_config = _.find(this.getState().config.blocks, function(block){
                return block.type == block_info.type
            })
            var blocks = this.getState().blocks
            blocks[data.designer_id][data.block_id] = JSON.parse(JSON.stringify(block_info))
            blocks[data.designer_id][data.block_id].setting.edit = block_config.setting_default.edit
            this.updateState({blocks: blocks})
            this.dispatch('block/create/success', data) 
        }.bind(this)) 
        this.external_vd.subscribe('block/child/create', function(data){
            var blocks = this.getState().blocks
            var externalBlocks = this.external_vd.getState().blocks
            blocks[data.designer_id][data.block_id] = JSON.parse(JSON.stringify(externalBlocks[data.designer_id][data.block_id]))
            this.updateState({blocks: blocks})
            this.updateSetting(data)
        }.bind(this))
    }

    this.subscribe('block/new', function(data){
        this.external_vd.dispatch('block/new', data)
    })
    this.subscribe('block/setting/fastUpdate', function(data){
        this.external_vd.dispatch('block/setting/fastUpdate', data)
    })
    this.subscribe('block/setting/update', function(data){
        var blocks = this.getStateExternal().blocks
        if(!_.isUndefined(blocks[data.designer_id][data.block_id])){
            this.external_vd.dispatch('block/setting/update', data)
        }
    })
    this.subscribe('history/undo', function(data){
        this.external_vd.dispatch('history/undo', data)
    })
    this.subscribe('history/return', function(data){
        this.external_vd.dispatch('history/return', data)
    })
    this.subscribe('template/load/success', function(data){
        var blocks = this.getState().blocks[data.designer_id]
        var blocksExternal = this.getStateExternal().blocks
        blocksExternal[data.designer_id] = JSON.parse(JSON.stringify(blocks))
        this.updateStateExternal({blocks: blocksExternal})
        this.external_vd.dispatch('content/update', {designer_id: data.designer_id})
    })
    this.subscribe('block/layout/update/success', function(data){
        var blocks = this.getState().blocks[data.designer_id]
        var blocksExternal = this.getStateExternal().blocks
        var result = data.result
        for(var key in result.delete) {
            delete blocksExternal[data.designer_id][result.delete[key]]
        }
        for(var key in result.update) {
            blocksExternal[data.designer_id][result.update[key]].setting.global = blocks[result.update[key]].setting.global
        }
        for(var key in result.new) {
            blocksExternal[data.designer_id][result.new[key]] = blocks[result.new[key]]
            blocksExternal[data.designer_id][result.new[key]].setting.edit = false
            this.external_vd.dispatch('block/setting/update', {designer_id: data.designer_id, block_id: result.new[key]})
        }
        this.updateStateExternal({blocks: blocksExternal})
    })

    this.subscribe('template/save/success', function() {
        this.alert_handler(this.getLocal('designer.text_success_template_save'), 'success')
    })
    this.subscribe('clone_block_success', function(data) {
        this.alert_handler(data.title + this.getLocal('designer.text_success_clone_block'), 'success')
    })
    this.subscribe('remove_block_success', function(data) {
        this.alert_handler(data.title + this.getLocal('designer.text_success_remove_block'), 'success')
    })

    this.alert_handler = function(text, type)
    {
        if(type == 'error') {
            alertify.error(text);
        }
        if(type == 'success') {
            alertify.success(text);
        }
    }

    this.updateBlocks = function(designer_id, blocks) {
        $.ajax({
            url: this.getState().config.update_settings_url,
            data: {blocks: JSON.stringify(blocks)},
            type: 'post',
            dataType: 'json',
            context: this,
            success: function(json){
                if(json['success']) {
                    var vdBlocks = this.getState().blocks
                    vdBlocks[designer_id] = json.blocks
                    this.updateState({blocks:vdBlocks})
                }
            }
        })
    }

    this.getStateExternal = function(){
        return this.external_vd.state
    };
    this.updateStateExternal = function(data){
        return this.external_vd.updateState(data)
    };

    this.dispatchExternal = function(action, state){
        this.external_vd.trigger(action, state);
    };

    this.subscribeExternal = function(action, callback){
        this.external_vd.on(action, callback);
    }
}.bind(d_visual_designer))()