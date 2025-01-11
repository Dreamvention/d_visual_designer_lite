function vd_block(tag) {
    tag.mixin({store:d_visual_designer});
    tag.state = {
        top: tag.parent ? tag.parent.getState().top : tag,
        level: tag.parent.getState().level,
        setting: JSON.parse(JSON.stringify(tag.opts.block.setting))
    };

    tag.state_updated = false;
    tag.state_always_update = !_.isUndefined(arguments[1])? !arguments[1] : false;

    tag.shouldUpdate = function(data, nextOpts) {
        return !_.isEqual(nextOpts.block.setting, tag.getState().setting) || tag.state_updated || this.state_always_update;
    };

    this.controlDisable = function() {
        this.state_always_update = true;
    };

    tag.on('update', function(){
        tag.setState('setting', JSON.parse(JSON.stringify(tag.opts.block.setting)));
    });

    tag.on('updated', function(){
        tag.state_updated = false;
    });

    tag.initState = function(data) {
        tag.setState(data);
        tag.state_updated = false;
    };


    tag.getState = function() {
        if(!_.isUndefined(arguments[0])){
            return !_.isUndefined(tag.state[arguments[0]]) ? tag.state[arguments[0]] : null;
        } else {
            return tag.state;
        }
    };

    tag.setState = function(){
        tag.state_updated = false;
        if(_.isObject(arguments[0])){
            for(var key in arguments[0]){
                tag.state_updated = !_.isEqual(arguments[0][key], tag.state[key]);
                tag.state[key] = arguments[0][key];
            }
        } else {
            tag.state_updated = !_.isEqual(arguments[1], tag.state[arguments[0]]);
            tag.state[arguments[0]] = arguments[1];
        }
    };
}