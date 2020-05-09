// Prefectureセレクトボックスに連動してCityセレクトボックスを変更する
$(document).on('change', '#post_prefecture_id', function() {
  return $.ajax({
    type: 'GET',
    url: '/posts/cities_select',
    data: {
      prefecture_id: $(this).val()
    }
  }).done(function(data) {
    return $('#cities_select').html(data);
  });
});

// 無限スクロール
// レポート一覧
$(document).on("turbolinks:load", function() {
  $('.post-cards').infiniteScroll({
    append : '.post-cards .card-index',
    history: false,
    button: '.loadmore-btn',
    scrollThreshold: false,
    path : 'nav ul.pagination a[rel=next]',
    hideNav: 'nav ul.pagination',
    status: '.page-load-status'
  })
})
$(document).on("turbolinks:load", function() {
  if(!$("nav ul.pagination")[0]) {
    $(".loadmore-btn").hide();
  }
})
