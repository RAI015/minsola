# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# $(window).on 'scroll', ->
#   scrollHeight = $(document).height()
#   scrollPosition = $(window).height() + $(window).scrollTop()
#   if (scrollHeight - scrollPosition) / scrollHeight <= 0.50
#     # スクロールの位置が下部5%の範囲に来た場合
#     $('.jscroll').jscroll
#       contentSelector: '.skill-list'
#       nextSelector: 'a.page-link'
#     return
#   return

# $(document).on 'turbolinks:load', ->
#   $('.paginate').infiniteScroll
#     path: "ul.pagination a[rel=next]"
#     append: "div.paginate div.row"
#     history: false
#     button: "#loadmore-btn"
#     hideNav: ".pagination"
#     scrollThreshold: false



    # $(".paginate").infiniteScroll({
    #   path: "ul.pagination a[rel=next]",
    #   append: ".paginate .row",
    #   elementScroll: true,
    #   history: false,
    #   prefill: false,
    #   status: ".page-load-status",
    #   hideNav: ".pagination"
    # });

  # $(function() {
  #   $('.home-post-cards.popular').infiniteScroll({
  #     append : '.home-post-cards.popular .post-card',
  #     history: false,
  #     button: '.home-posts-footer.popular .loadmore-btn',
  #     scrollThreshold: false,
  #     path : '.home-posts-footer.popular nav.pagination a[rel=next]',
  #     hideNav: '.home-posts-footer.popular .pagination'
  #   })
  # })
  # $(function () {
  #   if($(".home-posts-footer.popular nav.pagination")[0]) {
  #   } else {
  #       $(".home-posts-footer.popular .loadmore-btn").hide();
  #   }
  # });