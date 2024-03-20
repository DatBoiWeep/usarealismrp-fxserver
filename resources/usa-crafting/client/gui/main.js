var craftingInterfaceApp = new Vue({
    el: "#crafting-interface",
    data: {
        unlockedRecipes: [],
        modal: {
            recipe: {
                image: ""
            }
        },
        ITEM_IMAGES: []
    },
    methods: {
     showModal(recipe) {
         this.modal.recipe = recipe
        $("#modal").show()
     },
     closeModal() {
         $("#modal").hide()
     },
     attemptCraft() {
        $("#modal").hide()
        $.post('http://usa-crafting/attemptCraft', JSON.stringify({
            recipe: this.modal.recipe
        }));
    },
    getItemImage(itemName) {
        return "https://cfx-nui-interaction-menu/ui/images/" + this.ITEM_IMAGES[itemName]
    }
    },
    computed: {
         
    },
    filters: {
      displayMoney: function(value) {
        return value.formatMoney(2, '.', ',');
      }
    }
  })

$(function() {
    /* To talk with LUA */
    window.addEventListener('message', function(event) {
        if (event.data.type == "toggle") {
            if (document.body.style.display == "flex") {
                document.body.style.display = "none";
            } else {
                document.body.style.display = "flex";
                craftingInterfaceApp.ITEM_IMAGES = event.data.ITEM_IMAGES;
                $.post('http://usa-crafting/fetchUnlockedRecipes', JSON.stringify({}));
            }
        } else if (event.data.type == "gotUnlockedRecipes") {
            craftingInterfaceApp.unlockedRecipes = event.data.unlockedRecipes
        }
    });

    function close() {
        //document.body.style.display = "none";
        $.post('http://usa-crafting/close', JSON.stringify({}));
    }
    
    /* Close Menu */
    document.onkeydown = function(data) {
        if (data.which == 27) { // Escape key
            close();
        }
    };

    $("#craftCloseButton").click(() => {
        close()
    })

    // When the user clicks anywhere outside of the modal, close it
    /*
    window.onclick = function(event) {
        if (event.target == modal) {
            document.getElementById('modal').style.display = "none";
        }
    }
    */
});