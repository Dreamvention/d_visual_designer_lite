(function(){
    this.initContent = function(){
        $('.d_visual_designer, .d_visual_designer_backend').each(function(index, el){

            var send_data = {
                id: this.getState().config.id,
                route: this.getState().config.route
            }
            if(el.classList.contains('d_visual_designer_backend')){
                send_data['field_name'] = el.dataset["name"]
                if(typeof el.dataset["content"] !== 'undefined') {
                    send_data['content'] = el.dataset["content"]
                } else {
                    send_data['content'] = ''
                }
            } else {
                send_data['field_name'] = el.name
                send_data['content'] = el.value
            }

            $.ajax({
                url: 'index.php?route=extension/visual_designer/visual_designer/designer|loadSetting&'+this.getState().config.url_token,
                data: {setting: JSON.stringify(send_data)},
                type: 'post',
                dataType: 'json',
                context: this,
                beforeSend: function() {
                    if(el.classList.contains('d_visual_designer')){
                        $(el).closest('div').append('<div id="visual-designer-loader" class="la-ball-scale-ripple-multiple la-dark la-2x"><div></div><div></div><div></div></div>');
                        if ($(el).next().hasClass('note-editor')) {
                            $(el).next().fadeTo('slow', 0.5);
                        }else if ($(el).next().hasClass('cke')) {
                            $(el).next().fadeTo('slow', 0.5);
                        }  else {
                            $(el).fadeTo('slow', 0.5);
                        }
                    } else {
                        $(el).closest('div').append('<div id="visual-designer-static" class="la-ball-scale-ripple-multiple la-dark la-2x"><div></div><div></div><div></div></div>');
                    }
                },
                success: function(json){
                   if(json.success) {
                        var config = this.getState().config
                        config.independent[json.designer_id] = el.classList.contains('d_visual_designer_backend')?true: false
                        this.updateState({config: config})

                        var content = this.getState().content
                        content[json.designer_id] = json.content
                        this.updateState({content: content})

                        var blocks = this.getState().blocks
                        blocks[json.designer_id] = json.blocks
                        this.updateState({blocks: blocks})

                        $(el).before('<visual-designer id="'+json.designer_id+'" class="'+json.designer_id+'"></visual-designer>');
                        riot.mount(document.getElementById(json.designer_id))
                        this.dispatch('content/designer/init', {designer_id: json.designer_id})
                        setTimeout(function(){
                            this.dispatch('content/mode/update', {designer_id: json.designer_id, 'mode': 'designer'})
                        }.bind(this), 500)

                   }
                },
                complete: function(){
                    if(el.classList.contains('d_visual_designer')){
                        $(el).closest('div').find('div#visual-designer-loader').remove();
                        if ($(el).next().hasClass('note-editor')) {
                            $(el).next().fadeTo('slow', 1);
                        } else if ($(el).next().hasClass('cke')) {
                            $(el).next().fadeTo('slow', 1);
                        } else {
                            $(el).fadeTo('slow', 1);
                        }
                    } else {
                        $(el).closest('div').find('div#visual-designer-static').remove();
                    }
                }
            })

        }.bind(this));
    };

    this.subscribe('block/setting/update/end', function(data){
        this.dispatch('designer/update/content', {designer_id: data.designer_id})
    });

    this.subscribe('content/mode/update',function(data){
        var config = this.getState().config
        config.mode[data.designer_id] = data.mode
        this.updateState({config: config})
        this.dispatch('content/mode/update/success', {designer_id: data.designer_id})
    });

    this.subscribe('content/update',function(data){
        var content = this.getState().content
        content[data.designer_id] = data.content
        this.updateState({content: content})
        this.dispatch('designer/update/blocks', {designer_id: data.designer_id, post_action: ['content/update/success'].concat(data.post_action)})
    });

    this.subscribe('content/codeview', function(data) {
        this.dispatch('designer/update/content', {designer_id: data.designer_id, post_action: ['content/codeview/success']})
    })
}.bind(d_visual_designer))()
