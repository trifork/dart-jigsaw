var current_position = [[0,0],[0,1],[0,2],[1,0],[1,1],[1,2],[2,0],[2,1],[2,2]];
function move(jigsaw, loc) {
    var hole="";
    if (/hole/.test(jigsaw.className)) {
        hole = " hole";
    }
    jigsaw.className = "move"+loc[0]+loc[1]+hole;

}
function randInt(N) {
    return Math.floor(Math.random()*N);
}

function swap(pieces, i, j) {
    var tmp = pieces[i];
    pieces[i] = pieces[j];
    pieces[j] = tmp;
}
function shuffle(pieces) {
    var N = pieces.length;
    while(N--) {
        var idx = randInt(N);
        swap(pieces, N,idx);
    }
}

function randomize() {
    shuffle(current_position);
    for (var i=0;i<3;i++) {
        for (var j=0;j<3;j++) {
            var p =current_position[i*3+j];
            var el =document.getElementById("sq"+i+j);
            move(el,p);
        }
    }
    var sq00 = document.getElementById("sq00");
    sq00.className = sq00.className + " hole";


}

function userMove(e) {
    var el = e.target;
    if (!(/hole/.test(el.className))) {
        console.log(el);
        var loc_i = parseInt(el.className.substring(4,5),10);
        var loc_j = parseInt(el.className.substring(5,6),10);
        var hole = document.getElementsByClassName("hole")[0];
        var hole_i = parseInt(hole.className.substring(4,5),10);
        var hole_j = parseInt(hole.className.substring(5,6),10);
        move(el,[hole_i,hole_j]);
        move(hole,[loc_i,loc_j]);

    }

}

document.getElementById('shuffle').addEventListener("click",randomize,false);
document.getElementById('jigsaw').addEventListener("click",userMove,false);

document.getElementById('go').addEventListener("click",function(){
    var menu = document.getElementById('menu');
    menu.className = "inactive";
    document.getElementById('jigsaw').className = "inactive";

    function afterTransition( event ) {
        menu.className = "inactive hidden";
        document.getElementById('buttons').className = "active";
        document.getElementById('jigsaw').className = "active";
    }

    menu.addEventListener( 'webkitTransitionEnd', afterTransition, false );
    menu.addEventListener( 'transitionend', afterTransition, false );




},false);
