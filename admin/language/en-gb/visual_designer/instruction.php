<?php

$_['text_instruction_full']         = '
<div class="row">
<div class="col-md-2">

<ul class="nav nav-pills nav-stacked">
<li class="active"><a href="#in_install"  data-toggle="tab">Installation and Updating</a></li>
<li><a href="#in_setup"  data-toggle="tab">Setup</a></li>

</ul>
</div>
<div class="col-md-10">
<div class="tab-content">
    <div id="in_install" class="tab-pane active">
        <h3>Installation</h3>
            <ol>
                <li>Unzip distribution file</li>
                <li>Upload everything from the folder <code>UPLOAD</code> into the root folder of you shop</li>
                <li>Goto admin of your shop and navigate to extensions -> modules -> Visual Designer </li>
                <li>Click install button</li>
            </ol>
            <h3>Updating</h3>
            <ol>
                <li>Unzip distribution file</li>
                <li>Upload everything from the folder <code>UPLOAD</code> into the root folder of you shop</li>
                <li>Click overwrite for all files</li>
            </ol>
            <div class="bs-callout bs-callout-info">
            <h4>Note!</h4>
            <p>Although we follow strict standards that do not allow feature updates to cause a full reinstall of the module, still it may happen that major releases require you to uninstall/install the module again before new feature take place. </p>
            </div>
            <div class="bs-callout bs-callout-warning">
            <h4>Warning!</h4>
            <p>If you have made custom corrections to the code, your code will be rewritten and lost once you update the module. </p>
            </div>
            
        </div>
    <div id="in_setup" class="tab-pane">
        <div class="tab-body">
        <h3>Adding a new block</h3>
        <ol>
            <li>Click the plus button on the top</li>
            <li>Enter the name</li>
            <li>Select type block</li>
            <li>Select width block</li>
            <li>Select align block</li>
            <li>After you have entered all the data, press save.</li>
        </ol>
        <h3>Edit block</h3>
        <ol>
            <li>Click the pencil button on the right</li>
            <li>After you have entered all your changes, press save.</li>
        </ol>
        <h3>Sorting block</h3>
        <ol>
            <li>Drag block holding the button on the left side</li>
            <li>After you have entered all your changes, press save.</li>
        </ol>
        </div>
    </div>
</div>
';