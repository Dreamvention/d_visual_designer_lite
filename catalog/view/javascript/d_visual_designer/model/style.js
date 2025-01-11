(function(){
    /**
     * Render style for block
     */
    this.subscribe('block/style/update', function(data) {
        var block_info = this.getState().blocks[data.designer_id][data.block_id];

        var baseSelector = '[data-id='+data.block_id+'] .block-content[data-is="vd-block-'+block_info.type+'"]';
        $('head').find('style#'+data.designer_id+'-'+data.block_id).remove();

        var styleTag = '<style id="'+data.designer_id+'-'+data.block_id+'">';

        for(var key in data.styles) {
            styleTag += baseSelector+' '+key+'{';
            for(var name in data.styles[key]){
                if(data.styles[key][name]){
                    styleTag += name + ':'+data.styles[key][name]+';';
                }
            }
            styleTag += '}';
        }
        styleTag += '<style>';
        $('head').append(styleTag);
    });
    /**
     * Render style for block
     */
    this.subscribe('block/style/media/update', function(data) {
        var block_info = this.getState().blocks[data.designer_id][data.block_id];

        var baseSelector = '[data-id='+data.block_id+'] .block-content[data-is="vd-block-'+block_info.type+'"]';
        $('head').find('style#media-'+data.designer_id+'-'+data.block_id).remove();
        var medias = {
            'phone': '@media screen and (max-width: 767px)',
            'tablet': '@media screen and (min-width: 768px) and (max-width: 991px)',
            'desktop': '@media screen and (min-width: 992px)'
        };
        var styleTag = '<style id="media-'+data.designer_id+'-'+data.block_id+'">';

        for(var key in data.styles) {
            styleTag += medias[key]+'{';
 
            var styles = data.styles[key];
            for (var selector in styles) {
                styleTag += baseSelector+' '+selector+'{';
                for(var name in styles[selector]){
                    if(styles[selector][name]){
                        styleTag += name + ':'+styles[selector][name]+';';
                    }
                }
                styleTag += '}';
            }

            styleTag += '}';
        }
        styleTag += '<style>';
        
        $('head').append(styleTag);
    });
}.bind(d_visual_designer))();