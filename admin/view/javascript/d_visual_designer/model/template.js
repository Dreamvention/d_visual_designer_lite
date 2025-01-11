(function(){
    this.subscribe('template/save', function(data) {
        var blocks = this.getState().blocks[data.designer_id]
        var send_data = data.setting;
        send_data.setting = JSON.stringify(blocks)
        $.ajax({
            url: 'index.php?route=extension/visual_designer/visual_designer/template|save&'+this.getState().config.url_token,
            dataType: 'json',
            type: 'post',
            data: send_data,
            context: this,
            success: function(json){
                if(json.success) {
                    this.updateState({templates: json.templates})
                }
                this.dispatch('template/save/success', {designer_id: data.designer_id})
            }
        })
    });
    this.subscribe('template/load', function(data) {
        var send_data = {
            config: data.config,
            template_id: data.template_id
        }
        $.ajax({
            url: 'index.php?route=extension/visual_designer/visual_designer/template|getTemplate&'+this.getState().config.url_token,
            dataType: 'json',
            type: 'post',
            data: send_data,
            context: this,
            success: function(json){
                if(json.success){
                    var blocks = this.getState().blocks
                    blocks[data.designer_id] = json.setting
                    this.updateState({blocks:blocks})
                }
                this.dispatch('template/load/success', {designer_id: data.designer_id})
            }
        })
    });
}.bind(d_visual_designer))()
