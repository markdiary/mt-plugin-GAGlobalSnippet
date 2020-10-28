package GAGlobalSnippet::Tags;
use strict;
use warnings;
use base qw(MT::Plugin);

sub _hdlr_google_analytics {
    my ($ctx, $args, $cond) = @_;
    my $create = "";
    my $GTAGmeasurement = "";
    my $plugin = MT->component("GAGlobalSnippet");
    my $scope = "blog:".$ctx->stash('blog_id');
    my $GTAGCustom = $plugin->get_config_value('mdcGTAGCustom',$scope);
    $GTAGmeasurement = $args->{profile} ne "" ?  $args->{profile} : $plugin->get_config_value('mdcGTAGmeasurement',$scope);

    if($GTAGCustom ne ""){
        $GTAGCustom =~ s/[\x00-\x1F\x7F]//g;
    }
# Exclude  Preview Mode
    my $app = MT->instance;
    my $mode = $app->mode;
    return '' if $mode =~ /^preview_|^api/;

    my $out = <<"GTAGSNIPPET";
<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=$GTAGmeasurement"></script>
<script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());

      $GTAGCustom
      gtag('config', '$GTAGmeasurement');
GTAGSNIPPET
    $out = $out . "</script>". "\n";

    return $out;
}

1;
