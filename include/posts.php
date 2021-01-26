<?php
	function next_prev_posts($index,$post_keys,$posts){
		if ($index === null) return;
		echo "<div class='container'>";
		echo "<div class='row'>";
		if ($index != count($post_keys) - 1){
			$previous_post_name = $post_keys[$index+1];
			echo "<div class='col-sm text-center'>Previous Post: <a href='?p=" . $previous_post_name . "'>" . $posts[$previous_post_name]->title . "</a></div>";
		}
		if ($index != 0){
			$next_post_name = $post_keys[$index-1];
			echo "<div class='col-sm text-center'>Next Post: <a href='?p=" . $next_post_name . "'>" . $posts[$next_post_name]->title . "</a></div>";
		}
		echo "</div>";
		echo "</div>";
	}
	class PostData{
		public $date;
		public $title;
		public function __construct($date_str,$title_str){
			$this->date = strtotime($date_str);
			$this->title = $title_str;
		}
	}
	$posts = array(
		"symbio-ink-waltz" => new PostData('4th April 2020',"Symbio Ink Waltz"),
		"nov-21-piano" => new PostData('21st November 2020',"Foggy Afternoon Piano"),
		"hex-shader-applet" => new PostData('21st January 2021',"Hex Shader")
	);
	function post_compare($postkey1,$postkey2){
		global $posts;
		if ($posts[$postkey1]->date==$posts[$postkey2]->date) {
			return 0;
		}
		return ($posts[$postkey1]->date < $posts[$postkey2]->date)? -1 : 1;
	}
	$post_keys = array_keys($posts);
	uasort($post_keys,'post_compare');
	$post_keys = array_reverse($post_keys);
	$list_posts = true;
	$posts_page = 0;
	if (isset($_GET["pg"])){
		$posts_page = intval($_GET["pg"]);
		if ($posts_page < 0 || $posts_page >= count($post_keys)/5) $posts_page = 0;
	}
	if (isset($_GET["p"])){
		$post_name = $_GET["p"];
		$post_data = $posts[$post_name];
		if ($post_data != null){
			echo "<h3 class='text-center'>" . $post_data->title . "</h3><h4 class='text-center'>" . date("F jS, Y",$posts[$post_name]->date) . "</h4>";
			$index = array_search($post_name,$post_keys);
			next_prev_posts($index,$post_keys,$posts);
			if (@include($_SERVER['DOCUMENT_ROOT']."/../posts/".$post_name.".php")){
				$list_posts = false;
				next_prev_posts($index,$post_keys,$posts);
			}
			else {
				echo "<p>" . $post_name . " in database, but no corresponding file!</p>";
			}
		}
		else {
			echo "<p>" . $post_name . " not found!</p>";
		}
	}
	if ($list_posts){
		echo "<div class='postcontainer'>";
		echo "<h2 class='text-center'>Posts</h2>";
		for($i = $posts_page * 5; $i < min(count($post_keys),($posts_page+1)*5); $i++){
			$post_name = $post_keys[$i];
			$post_data = $posts[$post_name];
			echo "<p>" . date("l jS \of F Y",$post_data->date) . ": <a href='?p=" . $post_name . "'>" . $post_data->title . "</a></p>";
		}
		if ($posts_page > 0){
			echo "<p><a href='?pg=".($posts_page-1)."'>Newer Posts</a></p>";
		}
		$pages_count = (int)(count($post_keys)/5);
		if ($posts_page < $pages_count){
			echo "<p><a href='?pg=".($posts_page+1)."'>Older Posts</a></p>";
		}
		echo "</div>";
	}
?>