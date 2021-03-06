jQuery(function($){

    ///////////////////////
    // ANALYTICS (GOOGLE)
    //////////////////////
    var gAnalytics = {
        event: function(){
            var data;

            data = $(this).data();

            ga('send', 'event', 'button', 'click', data.event);
        }
    };

    $('.ga-btn').on('click', gAnalytics.event);


    ///////////////////////
    //BG FULL
    //////////////////////

    var theWindow        = $(window),
        $bg1              = $(".response-img");

    function resizeBg(aspectRatio1) {

        if ( (theWindow.width() / theWindow.height()) < aspectRatio1 ) {
            $bg1
                .removeClass('bgf-width')
                .addClass('bgf-height');
        } else {
            $bg1
                .removeClass('bgf-height')
                .addClass('bgf-width');
        }

    }


    //BLOCK HEIGHT
    $(window).resize(function() {
        $('#bg').css({
            height: $(window).height()
        });
    });


    ///////////////////////
    //SLIDE SHARE MENU
    //////////////////////

    var flag = true;
    var blockMenuRight = $("#share-block");

    $("#share-menu").click(function(){
        if (flag)
        {
            flag = false;
            if(!(blockMenuRight.hasClass("active-menu"))) {
                blockMenuRight.addClass("active-menu");
                blockMenuRight.animate({width:"+=240"},function(){
                    flag = true;
                });
            } else {
                blockMenuRight.animate({width:"-=240"},function(){
                    blockMenuRight.removeClass("active-menu");
                    flag = true;
                });
            }
        }
        return false;
    });


    ///////////////////////
    //PARALLAX
    //////////////////////
    $('.parallax-layer')
        .parallax({
            mouseport: $("#bg"),
            yparallax: false,
            xparallax: '150px',
            xorigin: 0
        }, {
            xparallax: 0.02
        });


    ///////////////////////
    //LOAD IMAGES
    //////////////////////

    theWindow.resize(function() {

        var aspectRatio1;

        $('.response-img').each(function(){

            var layerImg = $(this);
            var data;

            if($(window).width()>1700) {

                data = layerImg.data('high');
                aspectRatio1 = 2560 / 1440;

            } else if($(window).width()<1700 && $(window).width()>1400) {

                data = layerImg.data('medium');
                aspectRatio1 = 1600 / 708;

            } else if($(window).width()<1400 && $(window).width()>1280){

                data = layerImg.data('small');
                aspectRatio1 = 1200 / 700;

            } else {

                data = layerImg.data('micro');
                aspectRatio1 = 1280 / 500;

            }

            if(layerImg.attr('src') != data){
                layerImg.attr('src', data);
            }

        });

        resizeBg(aspectRatio1);

    }).trigger("resize");

    setTimeout(
        function(){
            theWindow.trigger("resize");
        }, 500
    );

    showMore = function() {
        var showcase = $('.showcase-wrapper');
        var button = $('.showcase', showcase);
        bottom = parseInt($(showcase).css('bottom'));
        $(showcase).delay(1500).css({
            bottom:'-100px',
            opacity: 0
        }).animate({
            bottom: bottom,
            opacity: 1
        }, {
            duration: 'slow',
            easing: 'easeInOutBack',
            complete: function() {
                $(showcase).removeAttr('style');
            }
        });

        $(button).on('click', function(event){
            event.preventDefault();
            $(button).animate({
                bottom: '-100px',
                opacity: 0
            }, {
                duration: 400,
                easing: 'easeInOutBack',
                complete: function() {
                    $('#preloader').css({
                        backgroundColor: '#000000'
                    }).fadeIn('slow',function() {
                        window.location.href = $(button).attr('href');
                    });
                }
            });

        });
    };


    //PRELOAD SITE
    $(window).load(function() {
        $('#preloader').delay(350).fadeOut('slow');
        $('body').delay(350).css({'overflow':'visible'});
        showMore();
    });

});