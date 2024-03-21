CONFIG = {
    RESTAURANTS = {
        BURGERSHOT = {
            JOB_NAME = "burgershot",
            REGISTER = {
                COORDS = vector3(-1195.634, -893.85, 13.88616),
                MENU = {
                    {
                        header = "($250) Money Shot Burger",
                        context = "Double patty burger",
                        event = "bs:addOrderItem",
                        args = {
                            "Money Shot Burger",
                            "BURGERSHOT"
                        }
                    },
                    {
                        header = "($185) The Bleeder Burger",
                        context = "Single patty burger",
                        event = "bs:addOrderItem",
                        args = {
                            "The Bleeder Burger",
                            "BURGERSHOT"
                        }
                    },
                    {
                        header = "($185) Torpedo Sandwich",
                        context = "Sandwich",
                        event = "bs:addOrderItem",
                        args = {
                            "Torpedo Sandwich",
                            "BURGERSHOT"
                        }
                    },
                    {
                        header = "($200) Meat Free Burger",
                        context = "Plant based burger",
                        event = "bs:addOrderItem",
                        args = {
                            "Meat Free Burger",
                            "BURGERSHOT"
                        }
                    },
                    {
                        header = "($100) French Fries",
                        context = "Crispy french fries",
                        event = "bs:addOrderItem",
                        args = {
                            "French Fries",
                            "BURGERSHOT"
                        }
                    },
                    {
                        header = "($85) Coca Cola",
                        context = "A refreshing beverage",
                        event = "bs:addOrderItem",
                        args = {
                            "Coca Cola",
                            "BURGERSHOT"
                        }
                    },
                    {
                        header = "Done",
                        context = "Register the new order",
                        event = "bs:registerNewOrder",
                        args = {
                            "BURGERSHOT"
                        }
                    }
                }
            },
            COOKING = {
                COORDS = vector3(-1195.372, -897.1624, 14.808616)
            },
            COUNTER = {
                COORDS = vector3(-1192.118, -893.2803, 13.88616)
            },
            ITEMS = {
                ["Money Shot Burger"] = {
                    PRICE = 250
                },
                ["The Bleeder Burger"] = {
                    PRICE = 185
                },
                ["Torpedo Sandwich"] = {
                    PRICE = 185
                },
                ["Meat Free Burger"] = {
                    PRICE = 200
                },
                ["French Fries"] = {
                    PRICE = 100
                },
                ["Coca Cola"] = {
                    PRICE = 85
                },
            },
            JOB_VEHICLE = {
                MODEL = "nspeedo",
                SPAWN = {
                    X = -1204.4656982422,
                    Y = -901.98754882812,
                    Z = 13.473096847534
                },
                LIVERY_NUM = 1
            },
            PROPERTY_NAME = "Burgershot",
            OUTFIT = {
                MALE = {
                    TORSO = {
                        COMPONENT = 406,
                        TEXTURE = 1
                    },
                    ARMS = {
                        COMPONENT = 6,
                        TEXTURE = 0
                    }
                },
                FEMALE = {
                    TORSO = {
                        COMPONENT = 420,
                        TEXTURE = 2
                    },
                    ARMS = {
                        COMPONENT = 9,
                        TEXTURE = 0
                    }
                }
            }
        },
        CATCAFE = {
            JOB_NAME = "catcafe",
            REGISTER = {
                COORDS = vector3(-584.7996, -1061.443, 22.3442),
                MENU = {
                    {
                        header = "($125) Fruit Tart",
                        context = "A delicious fruit tart snack",
                        event = "bs:addOrderItem",
                        args = {
                            "Fruit Tart",
                            "CATCAFE"
                        }
                    },
                    {
                        header = "($200) Pancake",
                        context = "A delicious pancake",
                        event = "bs:addOrderItem",
                        args = {
                            "Pancake",
                            "CATCAFE"
                        }
                    },
                    {
                        header = "($125) Miso Soup",
                        context = "Delicious bowl of miso soup",
                        event = "bs:addOrderItem",
                        args = {
                            "Miso Soup",
                            "CATCAFE"
                        }
                    },
                    {
                        header = "($250) UWU Sandwich",
                        context = "A delicious cat cafe sandwich",
                        event = "bs:addOrderItem",
                        args = {
                            "UWU Sandwich",
                            "CATCAFE"
                        }
                    },
                    {
                        header = "($125) Weepy Cupcake",
                        context = "A delicious cat cafe cupcake",
                        event = "bs:addOrderItem",
                        args = {
                            "Weepy Cupcake",
                            "CATCAFE"
                        }
                    },
                    {
                        header = "($125) Moon Mochi",
                        context = "Rice cake wrapped ice cream",
                        event = "bs:addOrderItem",
                        args = {
                            "Moon Mochi",
                            "CATCAFE"
                        }
                    },
                    {
                        header = "($250) Buddha Bowl",
                        context = "The signature buddha bowl",
                        event = "bs:addOrderItem",
                        args = {
                            "Buddha Bowl",
                            "CATCAFE"
                        }
                    },
                    {
                        header = "($250) Bento Box",
                        context = "The signature bento box",
                        event = "bs:addOrderItem",
                        args = {
                            "Bento Box",
                            "CATCAFE"
                        }
                    },
                    {
                        header = "($85) Espresso",
                        context = "A cup of espresso",
                        event = "bs:addOrderItem",
                        args = {
                            "Espresso",
                            "CATCAFE"
                        }
                    },
                    {
                        header = "($85) Macchiato",
                        context = "A cup of macchiato",
                        event = "bs:addOrderItem",
                        args = {
                            "Macchiato",
                            "CATCAFE"
                        }
                    },
                    {
                        header = "($85) Latte",
                        context = "A classic latte",
                        event = "bs:addOrderItem",
                        args = {
                            "Latte",
                            "CATCAFE"
                        }
                    },
                    {
                        header = "($85) Mocha",
                        context = "A classic mocha coffee",
                        event = "bs:addOrderItem",
                        args = {
                            "Mocha",
                            "CATCAFE"
                        }
                    },
                    {
                        header = "($85) Blueberry Bubble Tea",
                        context = "A blueberry bubble tea",
                        event = "bs:addOrderItem",
                        args = {
                            "Blueberry Bubble Tea",
                            "CATCAFE"
                        }
                    },
                    {
                        header = "Done",
                        context = "Register the new order",
                        event = "bs:registerNewOrder",
                        args = {
                            "CATCAFE"
                        }
                    }
                }
            },
            COOKING = {
                COORDS = vector3(-588.5706, -1059.424, 22.35617)
            },
            COUNTER = {
                COORDS = vector3(-585.158, -1063.622, 22.3442)
            },
            ITEMS = {
                ["Fruit Tart"] = {
                    PRICE = 125
                },
                ["Pancake"] = {
                    PRICE = 200
                },
                ["Miso Soup"] = {
                    PRICE = 125
                },
                ["UWU Sandwich"] = {
                    PRICE = 250
                },
                ["Weepy Cupcake"] = {
                    PRICE = 125
                },
                ["Moon Mochi"] = {
                    PRICE = 125
                },
                ["Buddha Bowl"] = {
                    PRICE = 250
                },
                ["Bento Box"] = {
                    PRICE = 250
                },
                ["Espresso"] = {
                    PRICE = 85
                },
                ["Macchiato"] = {
                    PRICE = 85
                },
                ["Latte"] = {
                    PRICE = 85
                },
                ["Mocha"] = {
                    PRICE = 85
                },
                ["Blueberry Bubble Tea"] = {
                    PRICE = 85
                },
            },
            JOB_VEHICLE = { -- todo: add heading
                MODEL = "nspeedo",
                SPAWN = {
                    X = -561.71411132812,
                    Y = -1071.2105712891,
                    Z = 22.178901672363
                },
                LIVERY_NUM = 3
            },
            PROPERTY_NAME = "Cat Cafe",
            OUTFIT = {
                MALE = {
                    TORSO = {
                        COMPONENT = 38,
                        TEXTURE = 13
                    },
                    ARMS = {
                        COMPONENT = 1,
                        TEXTURE = 1
                    }
                },
                FEMALE = {
                    TORSO = {
                        COMPONENT = 63,
                        TEXTURE = 1
                    },
                    ARMS = {
                        COMPONENT = 1,
                        TEXTURE = 1
                    }
                }
            }
        }
    }
}