<?php
$page_name = "Home";
?>

<?php
include_once($_SERVER['DOCUMENT_ROOT']."/../include/header.php");
?>
<div class="postcontainer">
<h2 class="text-center">Stuff</h2>
<?php
include_once($_SERVER['DOCUMENT_ROOT']."/../include/posts.php");
?>
</div>

<?php
include_once($_SERVER['DOCUMENT_ROOT']."/../include/footer.php");
?>