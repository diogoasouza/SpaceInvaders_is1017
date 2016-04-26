

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Alien Invasion</title>
        <link rel="shortcut icon" href="">
        <link href="assets/css/main.css" rel="stylesheet"/>   <!-- external style sheet-->
        <script src="assets/scripts/jquery-2.2.3.min.js" type="text/javascript"></script>
        <script>
            $ship = null;
            var wait = false;
            var numberBullets = 0;
            $tblAliens = null;
            var BULLET_WIDTH = 23;
            var BULLET_HEIGHT = 33;
            var ALIEN_WIDTH = 29;
            var ALIEN_HEIGHT = 43;
            var curBulletID = 1;
            var alienlist = [];
            var leftOrRight = 1;
            var intervalAliens = null;
            var firedBullets = []; // initialize empty array that will hold bullet objects
            var screenWidth = 0;
            var screenHeight = 0;
            var gameId = 0;
            var userId;
            var finished = false;
            $(document).ready(function () {
                $('html, body').css({
                    'overflow': 'hidden',
                    'height': '100%'
                });
                screenWidth = $(document).width();
                screenHeight = $(document).height();
                $ship = $('#ship');
                $tblAliens = $('#tblAliens');
                gameId = createGuid();
                userId = getQueryParam("userID");
                drawAliens();
                intervalAliens = setInterval(moveAliens, 30);
                var intervalEndGame = setInterval(checkEndOfGame, 300);
                $ship.css('top', (screenHeight - $ship.height() - 30) + "px");
                $ship.css('left', (screenWidth / 2 - $ship.width() / 2) + "px");
                $(document).keydown(function (e) {
                    moveShip(e);
                });
            });
            $(window).on('beforeunload', function () {
                getHighestScore();
            });

            function createGuid()
            {
                return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
                    var r = Math.random() * 16 | 0, v = c === 'x' ? r : (r & 0x3 | 0x8);
                    return v.toString(16);
                });
            }
            function drawAliens() {
                for (var i = 0; i < 5; i++) {
                    $tr = $('<tr></tr>');
                    for (var j = 0; j < 15; j++) {
                        $td = $('<td width=43px height=43px></td>');
                        $alien = $('<img>');
                        $alien.attr({"src": "assets/sprites/alien.gif"});
                        $alien.attr({"id": "alien_" + i + j});
                        $td.append($alien);
                        $tr.append($td);
                        alienlist.push($alien);
                    }
                    $tblAliens.append($tr);
                }

            }
            function getQueryParam(param) {
                location.search.substr(1)
                        .split("&")
                        .some(function (item) { // returns first occurence and stops
                            return item.split("=")[0] == param && (param = item.split("=")[1])
                        })
                return param
            }
            function saveScore(score) {
                postData = {
                    "gameID": gameId,
                    "score": score,
                    "userID": userId
                };
                $.post("ws_savescore", postData, function (data) {

                });
            }
            function getHighestScore() {
                if(!finished){
                   $.get("ws_readscores", function (data) {
                    finished = true;
                    alert("The highest Score is: " + data.score + "\n\It was score by: " + data.firstName + " " + data.lastName);
                    window.location.replace("index.jsp");
                }); 
                }
            }

            function checkEndOfGame() {
                if (!finished) {
                    if (alienlist.length == 0) {
                        getHighestScore();
                        clearInterval(intervalAliens);
                    }
                    for (var i = 0; i < alienlist.length; i++) {
                        if((alienlist[i][0].y+ALIEN_HEIGHT)>$ship.position().top){
                            getHighestScore();
                            clearInterval(intervalEndGame);
                            clearInterval(intervalAliens);
                        }
                    }
                }


            }
            function moveAliens() {
                var pos = $tblAliens.position();
                for (var i = 0; i < alienlist.length; i++) {
                    if (leftOrRight == 1) {
                        if ((alienlist[i][0].x + ALIEN_WIDTH + 10) >= screenWidth - 30) {
                            leftOrRight = 2;
                            $tblAliens.css('top', (pos.top + 10) + "px");
                        }
                    } else {
                        if ((alienlist[i][0].x - 10) <= 0) {
                            leftOrRight = 1;
                            $tblAliens.css('top', (pos.top + 10) + "px");
                        }
                    }
                    if (leftOrRight == 1) {
                        $tblAliens.css('left', (pos.left + 10) + "px");
                    } else {
                        $tblAliens.css('left', (pos.left - 10) + "px");
                    }
                }

            }




            function moveShip(e) {
                switch (e.which) {
                    case 32: // fire
                        if (!wait && numberBullets <= 5) {
                            createBullet();
                            numberBullets++;
                            wait = true;
                            setTimeout(function () {
                                wait = false;
                            }, 500);
                        }
                        break;
                    case 37: // left
                        var pos = $ship.position();
                        if (pos.left - 10 >= 0) {
                            $ship.css('left', (pos.left - 10) + 'px');
                        }
                        break;
                    case 39: // right
                        var pos = $ship.position();
                        //padding of 30px
                        if ((pos.left + 40) <= screenWidth) {
                            $ship.css('left', (pos.left + 10) + 'px');
                        }
                        break;
                    default:
                        return; // exit this handler for other keys
                }
            }



            function createBullet() {
                // Create image object
                $bulletObj = $('<img>');

                // Set attributes for the image object
                $bulletObj.attr({
                    "id": "bullet_" + curBulletID,
                    "src": "assets/sprites/shot.gif"
                });

                var initBulletX = $ship.position().left + $ship.width() / 2 - BULLET_WIDTH / 2;
                var initBulletY = $ship.position().top - BULLET_HEIGHT;
                // Set CSS position for the image object
                $bulletObj.css({
                    "position": "absolute",
                    "width": BULLET_WIDTH + "px",
                    "height": BULLET_HEIGHT + "px",
                    "top": initBulletY + "px",
                    "left": initBulletX + "px"
                });

                $('body').append($bulletObj);
                /*
                 * Create bullet object as a JSON object.  Look carefully at the properties.
                 * intervalID property will store timer interval ID
                 * bulletObj property stores the actual jQuery image object representing
                 * an individual bullet
                 */
                var bullet = {
                    "bulletID": curBulletID,
                    "intervalID": 0,
                    "bulletObj": $bulletObj
                }

                // Increment global variable
                curBulletID++;

                // Save bullet into a global array
                firedBullets.push(bullet);

                /*
                 * This is a major difference from what we did in class.
                 * Note that setInterval can take more than two arguments
                 * Each argument after the time interval is an argument that gets
                 * passed to the moveBullet function.  
                 * See documentation: 
                 * https://developer.mozilla.org/en-US/docs/Web/API/WindowTimers/setInterval
                 */
                bullet.intervalID = setInterval(moveBullet, 100, bullet);

            }


            function moveBullet(bullet) {
                // Get the jQuery bullet object from the DOM
                $firedBullet = $('#bullet_' + bullet.bulletID);

                // Get current Y position
                var posY = $firedBullet.position().top;

                // Get new position - move by 20 pixels up along Y-axis
                var newPosY = posY - 20;

                // Once the bullet is 5px away from the top, remove it
                if (newPosY > 5) {
                    $firedBullet.css("top", newPosY + "px");
                }
                else {
                    /* 
                     * Clear interval - it's easy because the interval is 
                     * now a property of the bullet JSON object
                     */
                    clearInterval(bullet.intervalID);
                    $firedBullet.remove(); // Remove bullet from the DOM
                    firedBullets.shift(); // Remove first element of the bullets array
                    numberBullets--;
                    saveScore(-1);
                }
                intersect(bullet);

            }
            function intersect(a) {
                b = a.bulletObj;
                for (var i = 0; i < alienlist.length; i++) {
                    if (alienlist[i][0].x <= (b.position().left + BULLET_WIDTH) &&
                            b.position().left <= (alienlist[i][0].x + ALIEN_WIDTH) &&
                            alienlist[i][0].y <= (b.position().top + BULLET_HEIGHT) &&
                            b.position().top <= (alienlist[i][0].y + ALIEN_HEIGHT)) {
                        b.remove();
                        clearInterval(a.intervalID);
                        firedBullets.splice(firedBullets.indexOf(b), 1);
                        alienlist[i].remove();
                        alienlist.splice(i, 1);
                        numberBullets--;
                        saveScore(1);
                    }
                }

            }
        </script>

    </head>
    <body>
        <table id="tblAliens"></table>
        <img src="assets/sprites/ship.gif" id="ship"/>
    </body>
</html>
