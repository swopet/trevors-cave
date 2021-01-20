<ul class = "navbar">
    <?php
        $urls = array(
            'Home' => './',
            'About' => './about.php',
        );
        
        foreach ($urls as $name => $url) {
            print '<li '.(($page_name === $name) ? ' class="active" ': '').
                '><a href="'.$url.'">'.$name.'</a></li>';
        }
    ?>
</ul>