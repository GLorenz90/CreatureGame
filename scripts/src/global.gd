extends Node

# GAME STATE =======================================================================================
var cur_character_index := 0;

# CONSTANTS =============================================================================================
enum ABILITIES {
  JUMP,
  SING,
  CHARGE,
  DANCE,
  FIRE
}
var main: Main;
const char_dino = preload("res://scenes/characters/char_dino.tscn");
const char_bird = preload("res://scenes/characters/char_bird.tscn");
const char_elephant = preload("res://scenes/characters/char_elephant.tscn");
const CHARACTERS = [
  char_dino,
  char_elephant,
  char_bird
];

# FUNCTIONS ========================================================================================

func increment_character_index():
  cur_character_index += 1;
  if(cur_character_index > CHARACTERS.size() - 1):
    cur_character_index = 0;
#end increment_character_index

func get_next_character():
  increment_character_index();
  return CHARACTERS[cur_character_index].instantiate();
#end get_next_character
