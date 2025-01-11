(function(){

    this.subscribe('designer/update/blocks',function(data){
        var contents = this.getState().content
        $.ajax({
            url: 'index.php?route=extension/visual_designer/visual_designer/designer|updateContent&'+this.getState().config.url_token,
            dataType: 'json',
            type: 'post',
            data: {content: contents[data.designer_id]},
            context: this,
            success: function(json){
                if(json.success) {
                    var blocks = this.getState().blocks
                    blocks[data.designer_id] = json.setting
                    this.updateState({blocks: blocks})

                    if(!_.isEmpty(data.post_action)){
                        for (var key in data.post_action) {
                            this.dispatch(data.post_action[key], {designer_id: data.designer_id})
                        }
                    }

                    this.dispatch('designer/update/blocks/success', {designer_id: data.designer_id})
                }
            }
        })
    });

    this.subscribe('designer/update/content',function(data){
        var blocks = this.getState().blocks[data.designer_id]
        var send_data = {
            setting: JSON.stringify(blocks)
        }
        $.ajax({
            url: 'index.php?route=extension/visual_designer/visual_designer/designer|getContent&'+this.getState().config.url_token,
            dataType: 'json',
            type: 'post',
            data: send_data,
            context: this,
            success: function(json){

                if(json.success) {
                    content = this.getState().content
                    content[data.designer_id] = json.content
                    this.updateState({content: content})
                    if(!_.isEmpty(data.post_action)){
                        for (var key in data.post_action) {
                            this.dispatch(data.post_action[key], {designer_id: data.designer_id})
                        }
                    }
                    this.dispatch('designer/update/content/success', {designer_id: data.designer_id, content: json.content})
                } else {
                    this.dispatch('designer/update/content/failed', {designer_id: data.designer_id, error: json.error})
                }
            }
        })
    })

    this.subscribe('designer/frontend',function(data){
        var config = this.getState().config

        var url_param = ''

        if(!_.isUndefined(config.route_info['frontend_full_param']) && config.route_info.frontend_full_param){
            url_param = '&field_name='+data.fieldName
        }
        $.ajax({
            type: 'post',
            url: data.form.attr('action'),
            data: data.form.serialize(),
            context: this,
            success: function(response) {
                window.location.href = config.frontend+url_param
            }
        });
    })
}.bind(d_visual_designer))()
