document.write('<link rel="stylesheet" href="https://github.githubassets.com/assets/gist-embed-33f755ffe42a.css">')
document.write('<div id=\"gist92908546\" class=\"gist\">\n    <div class=\"gist-file\" translate=\"no\">\n      <div class=\"gist-data\">\n        <div class=\"js-gist-file-update-container js-task-list-container file-box\">\n  <div id=\"file-stock7-py\" class=\"file my-2\">\n    \n  <div itemprop=\"text\" class=\"Box-body p-0 blob-wrapper data type-python  \">\n\n      \n<div class=\"js-check-bidi js-blob-code-container blob-code-content\">\n\n  <template class=\"js-file-alert-template\">\n  <div data-view-component=\"true\" class=\"flash flash-warn flash-full d-flex flex-items-center\">\n  <svg aria-hidden=\"true\" height=\"16\" viewBox=\"0 0 16 16\" version=\"1.1\" width=\"16\" data-view-component=\"true\" class=\"octicon octicon-alert\">\n    <path fill-rule=\"evenodd\" d=\"M8.22 1.754a.25.25 0 00-.44 0L1.698 13.132a.25.25 0 00.22.368h12.164a.25.25 0 00.22-.368L8.22 1.754zm-1.763-.707c.659-1.234 2.427-1.234 3.086 0l6.082 11.378A1.75 1.75 0 0114.082 15H1.918a1.75 1.75 0 01-1.543-2.575L6.457 1.047zM9 11a1 1 0 11-2 0 1 1 0 012 0zm-.25-5.25a.75.75 0 00-1.5 0v2.5a.75.75 0 001.5 0v-2.5z\"><\/path>\n<\/svg>\n  \n    <span>\n      This file contains bidirectional Unicode text that may be interpreted or compiled differently than what appears below. To review, open the file in an editor that reveals hidden Unicode characters.\n      <a href=\"https://github.co/hiddenchars\" target=\"_blank\">Learn more about bidirectional Unicode characters<\/a>\n    <\/span>\n\n\n  <div data-view-component=\"true\" class=\"flash-action\">        <a href=\"{{ revealButtonHref }}\" data-view-component=\"true\" class=\"btn-sm btn\">  Show hidden characters\n  \n<\/a>\n<\/div>\n<\/div><\/template>\n<template class=\"js-line-alert-template\">\n  <span aria-label=\"This line has hidden Unicode characters\" data-view-component=\"true\" class=\"line-alert tooltipped tooltipped-e\">\n    <svg aria-hidden=\"true\" height=\"16\" viewBox=\"0 0 16 16\" version=\"1.1\" width=\"16\" data-view-component=\"true\" class=\"octicon octicon-alert\">\n    <path fill-rule=\"evenodd\" d=\"M8.22 1.754a.25.25 0 00-.44 0L1.698 13.132a.25.25 0 00.22.368h12.164a.25.25 0 00.22-.368L8.22 1.754zm-1.763-.707c.659-1.234 2.427-1.234 3.086 0l6.082 11.378A1.75 1.75 0 0114.082 15H1.918a1.75 1.75 0 01-1.543-2.575L6.457 1.047zM9 11a1 1 0 11-2 0 1 1 0 012 0zm-.25-5.25a.75.75 0 00-1.5 0v2.5a.75.75 0 001.5 0v-2.5z\"><\/path>\n<\/svg>\n<\/span><\/template>\n\n  <table class=\"highlight tab-size js-file-line-container js-code-nav-container js-tagsearch-file\" data-tab-size=\"8\" data-paste-markdown-skip data-tagsearch-lang=\"Python\" data-tagsearch-path=\"stock7.py\">\n        <tr>\n          <td id=\"file-stock7-py-L1\" class=\"blob-num js-line-number js-code-nav-line-number js-blob-rnum\" data-line-number=\"1\"><\/td>\n          <td id=\"file-stock7-py-LC1\" class=\"blob-code blob-code-inner js-file-line\">\n<\/td>\n        <\/tr>\n        <tr>\n          <td id=\"file-stock7-py-L2\" class=\"blob-num js-line-number js-code-nav-line-number js-blob-rnum\" data-line-number=\"2\"><\/td>\n          <td id=\"file-stock7-py-LC2\" class=\"blob-code blob-code-inner js-file-line\"><span class=pl-s1>regressor<\/span> <span class=pl-c1>=<\/span> <span class=pl-v>Sequential<\/span>()<\/td>\n        <\/tr>\n        <tr>\n          <td id=\"file-stock7-py-L3\" class=\"blob-num js-line-number js-code-nav-line-number js-blob-rnum\" data-line-number=\"3\"><\/td>\n          <td id=\"file-stock7-py-LC3\" class=\"blob-code blob-code-inner js-file-line\">\n<\/td>\n        <\/tr>\n        <tr>\n          <td id=\"file-stock7-py-L4\" class=\"blob-num js-line-number js-code-nav-line-number js-blob-rnum\" data-line-number=\"4\"><\/td>\n          <td id=\"file-stock7-py-LC4\" class=\"blob-code blob-code-inner js-file-line\"><span class=pl-s1>regressor<\/span>.<span class=pl-en>add<\/span>(<span class=pl-v>LSTM<\/span>(<span class=pl-s1>units<\/span> <span class=pl-c1>=<\/span> <span class=pl-c1>50<\/span>, <span class=pl-s1>return_sequences<\/span> <span class=pl-c1>=<\/span> <span class=pl-c1>True<\/span>, <span class=pl-s1>input_shape<\/span> <span class=pl-c1>=<\/span> (<span class=pl-v>X_train<\/span>.<span class=pl-s1>shape<\/span>[<span class=pl-c1>1<\/span>], <span class=pl-c1>1<\/span>)))<\/td>\n        <\/tr>\n        <tr>\n          <td id=\"file-stock7-py-L5\" class=\"blob-num js-line-number js-code-nav-line-number js-blob-rnum\" data-line-number=\"5\"><\/td>\n          <td id=\"file-stock7-py-LC5\" class=\"blob-code blob-code-inner js-file-line\"><span class=pl-s1>regressor<\/span>.<span class=pl-en>add<\/span>(<span class=pl-v>Dropout<\/span>(<span class=pl-c1>0.2<\/span>))<\/td>\n        <\/tr>\n        <tr>\n          <td id=\"file-stock7-py-L6\" class=\"blob-num js-line-number js-code-nav-line-number js-blob-rnum\" data-line-number=\"6\"><\/td>\n          <td id=\"file-stock7-py-LC6\" class=\"blob-code blob-code-inner js-file-line\">\n<\/td>\n        <\/tr>\n        <tr>\n          <td id=\"file-stock7-py-L7\" class=\"blob-num js-line-number js-code-nav-line-number js-blob-rnum\" data-line-number=\"7\"><\/td>\n          <td id=\"file-stock7-py-LC7\" class=\"blob-code blob-code-inner js-file-line\"><span class=pl-s1>regressor<\/span>.<span class=pl-en>add<\/span>(<span class=pl-v>LSTM<\/span>(<span class=pl-s1>units<\/span> <span class=pl-c1>=<\/span> <span class=pl-c1>50<\/span>, <span class=pl-s1>return_sequences<\/span> <span class=pl-c1>=<\/span> <span class=pl-c1>True<\/span>))<\/td>\n        <\/tr>\n        <tr>\n          <td id=\"file-stock7-py-L8\" class=\"blob-num js-line-number js-code-nav-line-number js-blob-rnum\" data-line-number=\"8\"><\/td>\n          <td id=\"file-stock7-py-LC8\" class=\"blob-code blob-code-inner js-file-line\"><span class=pl-s1>regressor<\/span>.<span class=pl-en>add<\/span>(<span class=pl-v>Dropout<\/span>(<span class=pl-c1>0.2<\/span>))<\/td>\n        <\/tr>\n        <tr>\n          <td id=\"file-stock7-py-L9\" class=\"blob-num js-line-number js-code-nav-line-number js-blob-rnum\" data-line-number=\"9\"><\/td>\n          <td id=\"file-stock7-py-LC9\" class=\"blob-code blob-code-inner js-file-line\">\n<\/td>\n        <\/tr>\n        <tr>\n          <td id=\"file-stock7-py-L10\" class=\"blob-num js-line-number js-code-nav-line-number js-blob-rnum\" data-line-number=\"10\"><\/td>\n          <td id=\"file-stock7-py-LC10\" class=\"blob-code blob-code-inner js-file-line\"><span class=pl-s1>regressor<\/span>.<span class=pl-en>add<\/span>(<span class=pl-v>LSTM<\/span>(<span class=pl-s1>units<\/span> <span class=pl-c1>=<\/span> <span class=pl-c1>50<\/span>, <span class=pl-s1>return_sequences<\/span> <span class=pl-c1>=<\/span> <span class=pl-c1>True<\/span>))<\/td>\n        <\/tr>\n        <tr>\n          <td id=\"file-stock7-py-L11\" class=\"blob-num js-line-number js-code-nav-line-number js-blob-rnum\" data-line-number=\"11\"><\/td>\n          <td id=\"file-stock7-py-LC11\" class=\"blob-code blob-code-inner js-file-line\"><span class=pl-s1>regressor<\/span>.<span class=pl-en>add<\/span>(<span class=pl-v>Dropout<\/span>(<span class=pl-c1>0.2<\/span>))<\/td>\n        <\/tr>\n        <tr>\n          <td id=\"file-stock7-py-L12\" class=\"blob-num js-line-number js-code-nav-line-number js-blob-rnum\" data-line-number=\"12\"><\/td>\n          <td id=\"file-stock7-py-LC12\" class=\"blob-code blob-code-inner js-file-line\">\n<\/td>\n        <\/tr>\n        <tr>\n          <td id=\"file-stock7-py-L13\" class=\"blob-num js-line-number js-code-nav-line-number js-blob-rnum\" data-line-number=\"13\"><\/td>\n          <td id=\"file-stock7-py-LC13\" class=\"blob-code blob-code-inner js-file-line\"><span class=pl-s1>regressor<\/span>.<span class=pl-en>add<\/span>(<span class=pl-v>LSTM<\/span>(<span class=pl-s1>units<\/span> <span class=pl-c1>=<\/span> <span class=pl-c1>50<\/span>))<\/td>\n        <\/tr>\n        <tr>\n          <td id=\"file-stock7-py-L14\" class=\"blob-num js-line-number js-code-nav-line-number js-blob-rnum\" data-line-number=\"14\"><\/td>\n          <td id=\"file-stock7-py-LC14\" class=\"blob-code blob-code-inner js-file-line\"><span class=pl-s1>regressor<\/span>.<span class=pl-en>add<\/span>(<span class=pl-v>Dropout<\/span>(<span class=pl-c1>0.2<\/span>))<\/td>\n        <\/tr>\n        <tr>\n          <td id=\"file-stock7-py-L15\" class=\"blob-num js-line-number js-code-nav-line-number js-blob-rnum\" data-line-number=\"15\"><\/td>\n          <td id=\"file-stock7-py-LC15\" class=\"blob-code blob-code-inner js-file-line\">\n<\/td>\n        <\/tr>\n        <tr>\n          <td id=\"file-stock7-py-L16\" class=\"blob-num js-line-number js-code-nav-line-number js-blob-rnum\" data-line-number=\"16\"><\/td>\n          <td id=\"file-stock7-py-LC16\" class=\"blob-code blob-code-inner js-file-line\"><span class=pl-s1>regressor<\/span>.<span class=pl-en>add<\/span>(<span class=pl-v>Dense<\/span>(<span class=pl-s1>units<\/span> <span class=pl-c1>=<\/span> <span class=pl-c1>1<\/span>))<\/td>\n        <\/tr>\n        <tr>\n          <td id=\"file-stock7-py-L17\" class=\"blob-num js-line-number js-code-nav-line-number js-blob-rnum\" data-line-number=\"17\"><\/td>\n          <td id=\"file-stock7-py-LC17\" class=\"blob-code blob-code-inner js-file-line\">\n<\/td>\n        <\/tr>\n        <tr>\n          <td id=\"file-stock7-py-L18\" class=\"blob-num js-line-number js-code-nav-line-number js-blob-rnum\" data-line-number=\"18\"><\/td>\n          <td id=\"file-stock7-py-LC18\" class=\"blob-code blob-code-inner js-file-line\"><span class=pl-s1>regressor<\/span>.<span class=pl-en>compile<\/span>(<span class=pl-s1>optimizer<\/span> <span class=pl-c1>=<\/span> <span class=pl-s>&#39;adam&#39;<\/span>, <span class=pl-s1>loss<\/span> <span class=pl-c1>=<\/span> <span class=pl-s>&#39;mean_squared_error&#39;<\/span>)<\/td>\n        <\/tr>\n        <tr>\n          <td id=\"file-stock7-py-L19\" class=\"blob-num js-line-number js-code-nav-line-number js-blob-rnum\" data-line-number=\"19\"><\/td>\n          <td id=\"file-stock7-py-LC19\" class=\"blob-code blob-code-inner js-file-line\">\n<\/td>\n        <\/tr>\n        <tr>\n          <td id=\"file-stock7-py-L20\" class=\"blob-num js-line-number js-code-nav-line-number js-blob-rnum\" data-line-number=\"20\"><\/td>\n          <td id=\"file-stock7-py-LC20\" class=\"blob-code blob-code-inner js-file-line\"><span class=pl-s1>regressor<\/span>.<span class=pl-en>fit<\/span>(<span class=pl-v>X_train<\/span>, <span class=pl-s1>y_train<\/span>, <span class=pl-s1>epochs<\/span> <span class=pl-c1>=<\/span> <span class=pl-c1>100<\/span>, <span class=pl-s1>batch_size<\/span> <span class=pl-c1>=<\/span> <span class=pl-c1>32<\/span>)<\/td>\n        <\/tr>\n  <\/table>\n<\/div>\n\n\n  <\/div>\n\n  <\/div>\n<\/div>\n\n      <\/div>\n      <div class=\"gist-meta\">\n        <a href=\"https://gist.github.com/mwitiderrick/e9bb8249e7ff8b60ac6f419786ab8852/raw/d6ce120ab05b5a86ac61081df76c5edd70b9ef08/stock7.py\" style=\"float:right\">view raw<\/a>\n        <a href=\"https://gist.github.com/mwitiderrick/e9bb8249e7ff8b60ac6f419786ab8852#file-stock7-py\">\n          stock7.py\n        <\/a>\n        hosted with &#10084; by <a href=\"https://github.com\">GitHub<\/a>\n      <\/div>\n    <\/div>\n<\/div>\n')
