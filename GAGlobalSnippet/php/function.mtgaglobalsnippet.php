<?php 
function smarty_function_mtgaglobalsnippet($args, &$ctx) {
    $blog = $ctx->stash('blog');
    $id = $blog->blog_id;
    $blog_config[$id] = $ctx->mt->db()->fetch_plugin_data("GAGlobalSnippet", "configuration:blog:$id");

    $GAProfile = isset($args['profile'])? $args['profile'] : $blog_config[$id][mdcGAProfile];
    $GADomain  = isset($args['domain'])? $args['domain'] : $blog_config[$id][mdcGADomain];
    $GACustom  = $blog_config[$id][mdcGACustom];
    $custom = isset($args['custom']) ? $args['custom'] : '';
    $GACustom = preg_replace('/[\x00-\x1f\x7f]/', '', $GACustom);
    $custom = preg_replace('/[\x00-\x1f\x7f]/', '', $custom);

$out = <<< GASNIPPET
<script type="text/javascript">
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
GASNIPPET;

    if($GAProfile != ''){
        $create = <<< GACREATE

  ga('create', '$GAProfile', '$GADomain');
  ga('send', 'pageview');
$custom
GACREATE;
        $out .= $create;
    } else {
        $out .= "\n". $GACustom . "\n";
        $out .= $custom . "\n";
    }

    $out .= "\n" . "</script>" ."\n";

    return ($out);
}
?>