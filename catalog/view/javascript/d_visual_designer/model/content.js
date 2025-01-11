(function(){
    this.subscribe('content/save', function(data) {
        var blocks = this.getState().blocks[data.designer_id];

        var send_data = {
            setting: JSON.stringify(blocks),
            route:this.getState().config.route[data.designer_id],
            id:this.getState().config.id[data.designer_id],
            field_name:this.getState().config.field_name[data.designer_id]
        };

        $.ajax({
            url: 'index.php?route=extension/visual_designer/visual_designer/designer|save',
            dataType: 'json',
            type: 'post',
            data: send_data,
            context: this,
            success: function(json){
                if(json.success) {
                    this.dispatch('save_content_success');
                } else {
                    this.dispatch('save_content_permission');
                }
            },
            error: function(){
                this.dispatch('save_content_permission');
            }
        });
    });
    this.subscribe('content/update', function(data){
        var blocks = this.getState().blocks[data.designer_id];
        var send_data = {
            setting: JSON.stringify(blocks)
        };

        $.ajax({
            url: 'index.php?route=extension/visual_designer/visual_designer/designer|updateBlocks',
            dataType: 'json',
            type: 'post',
            data: send_data,
            context: this,
            success: function(json){
                if(json.success) {
                    var oldBlocks = this.getState().blocks;
                    oldBlocks[data.designer_id] = json.blocks;
                    this.updateState({blocks: oldBlocks});
                }
            }
        });
    });
}.bind(d_visual_designer))();
