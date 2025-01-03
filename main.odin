package algebyte

import "core:fmt"
import rl "vendor:raylib"

Card :: struct {
  rectangle : rl.Rectangle,
  glyph : cstring
}

main :: proc() {
  rl.SetTraceLogLevel(rl.TraceLogLevel.WARNING)
  rl.InitWindow(800, 800, "Algebyte")
  rl.SetTargetFPS(rl.GetMonitorRefreshRate(rl.GetCurrentMonitor()))

  left_expression : string : "2x+1"
  right_expression : string : "0"
	
  left_cards :[dynamic]Card
  right_cards :[dynamic]Card
  selected_card : ^Card
  is_card_selected : bool

  CARD_BG_COLOR : rl.Color : rl.BLACK
  CARD_FG_COLOR : rl.Color : rl.WHITE
  CARD_FONT_SIZE : f32 : 64
  CARD_X_EXTENT : f32 : 1

  x_center : f32 = cast(f32)rl.GetScreenWidth() * 0.5 - CARD_FONT_SIZE * 0.25
  y_center : f32 = cast(f32)rl.GetScreenHeight() * 0.5 - CARD_FONT_SIZE * 0.25

  card_dimension := rl.Vector2{CARD_FONT_SIZE / 2 + 2 * CARD_X_EXTENT, CARD_FONT_SIZE}
  card_center := rl.Rectangle{x_center, y_center, card_dimension.x, card_dimension.y}

  spacing : f32 = 0
  #reverse for glyph in left_expression {
    spacing -= CARD_FONT_SIZE + CARD_X_EXTENT
    card_rectangle := rl.Rectangle{x_center + spacing - CARD_X_EXTENT, y_center, card_dimension.x, card_dimension.y}
    card_glyph : cstring = fmt.caprint(glyph)
    append(&left_cards, Card{card_rectangle, card_glyph})
  }

  spacing = 0
  for glyph in right_expression {
    spacing += CARD_FONT_SIZE + CARD_X_EXTENT
    card_rectangle := rl.Rectangle{x_center + spacing - CARD_X_EXTENT, y_center, card_dimension.x, card_dimension.y}
    card_glyph : cstring = fmt.caprint(glyph)
    append(&right_cards, Card{card_rectangle, card_glyph})
  }

  for {
  	if rl.WindowShouldClose() do break

  	if rl.IsMouseButtonDown(rl.MouseButton.LEFT) {
      if !is_card_selected {
        for &card in left_cards {
          if rl.CheckCollisionCircleRec(rl.GetMousePosition(), 1, card.rectangle) {
            selected_card = &card
            is_card_selected = true
            break
          }
        }

        for &card in right_cards {
          if rl.CheckCollisionCircleRec(rl.GetMousePosition(), 1, card.rectangle) {
            selected_card = &card
            is_card_selected = true
            break
          }
        }
      } else {
        selected_card.rectangle.x = cast(f32)rl.GetMouseX() - selected_card.rectangle.width * 0.5
        selected_card.rectangle.y = cast(f32)rl.GetMouseY() - selected_card.rectangle.height * 0.5
      }
  	}

    if rl.IsMouseButtonUp(rl.MouseButton.LEFT) {
      is_card_selected = false
    }

    rl.BeginDrawing()
    rl.ClearBackground(rl.DARKGRAY)
    rl.DrawFPS(0, 0)

    for card in left_cards {
      rl.DrawRectangleRec(card.rectangle, CARD_BG_COLOR)
      card_glyph_x := cast(i32)(card.rectangle.x + CARD_X_EXTENT)
      card_glyph_y := cast(i32)y_center
      rl.DrawText(card.glyph, cast(i32)(card.rectangle.x + CARD_X_EXTENT), cast(i32)card.rectangle.y, cast(i32)CARD_FONT_SIZE, CARD_FG_COLOR)
    }

    for card in right_cards {
      rl.DrawRectangleRec(card.rectangle, CARD_BG_COLOR)
      rl.DrawText(card.glyph, cast(i32)(card.rectangle.x + CARD_X_EXTENT), cast(i32)card.rectangle.y, cast(i32)CARD_FONT_SIZE, CARD_FG_COLOR)
    }

    rl.DrawText("=", cast(i32)(card_center.x + CARD_X_EXTENT), cast(i32)card_center.y, cast(i32)CARD_FONT_SIZE, CARD_FG_COLOR)
    
  	rl.EndDrawing()
  }
}
