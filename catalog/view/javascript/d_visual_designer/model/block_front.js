(function(){
    /**
     * Full update block setting with Ajax Request
     */
    this.subscribe('block/setting/update', function(data){
        var block_info = this.getState().blocks[data.designer_id][data.block_id];
        var send_data = {
            setting: JSON.stringify(block_info.setting),
            type:block_info.type
        };
        var blocks = this.getState().blocks;

        $.ajax({
            url: 'index.php?route=extension/visual_designer/visual_designer/designer|updateSetting',
            type: 'post',
            dataType: 'json',
            data: send_data,
            context: this,
            success: function(json) {
                if(json['success']){
                    this.dispatch('block/setting/update/begin');
                    var blocks = this.getState().blocks;

                    blocks[data.designer_id][data.block_id].setting = _.extend({}, json.setting);
                    this.updateState({blocks: blocks});
                    this.dispatch('history/backup', {block_id: data.block_id, designer_id: data.designer_id, fast: false});
                    if(this.getState().config.save_change){
                        this.dispatch('content/save', {designer_id: data.designer_id});
                    }
                }
            },
            complete: function() {
                setTimeout(function() {
                    this.dispatch('block/setting/update/end');
                }.bind(this), 2000);

            }
        });
    });
}.bind(d_visual_designer))();
