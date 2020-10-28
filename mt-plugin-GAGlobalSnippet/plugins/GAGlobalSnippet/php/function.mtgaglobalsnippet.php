<?php
function smarty_function_mtgaglobalsnippet($args, &$ctx) {
    $blog = $ctx->stash('blog');
    $id = $blog->blog_id;
    $blog_config[$id] = $ctx->mt->db()->fetch_plugin_data("GAGlobalSnippet", "configuration:blog:$id");

    $GTAGmeasurement = isset($args['profile'])? $args['profile'] : $blog_config[$id][mdcGTAGmeasurement];
    $GTAGCustom = $blog_config[$id][mdcGTAGCustom];
    $GTAGCustom = preg_replace('/[\x00-\x1f\x7f]/', '', $GTAGCustom);

$out = <<< GTAGSNIPPET
<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=$GTAGmeasurement"></script>
<script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());

      $GTAGCustom
      gtag('config', '$GTAGmeasurement');
GTAGSNIPPET;


    $out .= "\n" . "</script>" ."\n";

    return ($out);
}
?>
