<nav class = "navbar navbar-expand-sm bg-dark navbar-dark">
	<div class="navbar-header">
		<a class="navbar-brand" href="./">Trevor's Cave</a>
	</div>
	<ul class="navbar-nav">
	<?php
		$urls = array(
			'About' => './about.php',
		);
		
		foreach ($urls as $name => $url) {
			echo "<li class=\"nav-item".(($page_name===$name) ? " active\">" : "\">");
			echo "<a class=\"nav-link\" href=\"".(($page_name===$name) ? "#" : $url)."\">".$name."</a>";
			echo "</li>";
		}
	?>
	</ul>
</nav>