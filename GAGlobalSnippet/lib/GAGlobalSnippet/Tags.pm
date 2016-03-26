package GAGlobalSnippet::Tags;
use strict;
use warnings;
use base qw(MT::Plugin);

sub _hdlr_google_analytics {
    my ($ctx, $args, $cond) = @_;
    my $create = "";
    my $GAProfile = "";
    my $GADomain = "";
    my $plugin = MT->component("GAGlobalSnippet");
    my $scope = "blog:".$ctx->stash('blog_id');
    my $GACustom = $plugin->get_config_value('mdcGACustom',$scope);
    $GAProfile = $args->{profile} ne "" ?  $args->{profile} : $plugin->get_config_value('mdcGAProfile',$scope);
    $GADomain =  $args->{domain} ne "" ? $args->{domain} : $plugin->get_config_value('mdcGADomain',$scope);

    if($GACustom ne ""){
        $GACustom =~ s/[\x00-\x1F\x7F]//g;
    }
    my $custom = $args->{custom} if($args->{custom});
    
# Exclude  Preview Mode
    my $app = MT->instance;
    my $mode = $app->mode;
    return '' if $mode =~ /^preview_|^api/;

    my $out = <<"GASNIPPET";
<script type="text/javascript">
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
GASNIPPET

    if($GAProfile ne ""){
        $create = <<"GACREATE";

  ga('create', '$GAProfile', '$GADomain');
  ga('send', 'pageview');
$custom
GACREATE
        $out = $out . $create;
    } else {
        $out = $out . $GACustom ."\n";
        $out = $out . $custom . "\n" unless($custom ne "");
    }

$out = $out . "</script>". "\n";

    return $out;
}

1;