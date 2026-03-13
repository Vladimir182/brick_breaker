import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../brick_breaker.dart';

class Bat extends PositionComponent
    with DragCallbacks, HasGameReference<BrickBreaker> {
  Bat({
    required this.cornerRadius,
    required super.position,
    required super.size,
  }) : super(anchor: Anchor.center, children: [RectangleHitbox()]);

  final Radius cornerRadius;

  // final _paint = Paint()
  //   ..color = const Color(0xff1e6091)
  //   ..style = PaintingStyle.fill;

  // create bet using a canvas
  // @override
  // void render(Canvas canvas) {
  //   super.render(canvas);
  //   canvas.drawRRect(
  //     RRect.fromRectAndRadius(Offset.zero & size.toSize(), cornerRadius),
  //     _paint,
  //   );
  // }

  @override
  void render(Canvas canvas) {}

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // load a sprint
    final sprite = await game.loadSprite('graph.png');

    // Додаємо його як дитину, щоб він заповнив усю площу PositionComponent
    // We add it as a child so that it fills the entire area of the PositionComponent
    add(SpriteComponent(sprite: sprite, size: size));
  }

  //finger control
  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);

    if (game.playState != PlayState.playing) return;
    position.x = (position.x + event.localDelta.x).clamp(0, game.width);
  }

  // keyboard control

  @override
  void update(double dt) {
    super.update(dt);

    // Рухаємось лише якщо гра триває
    if (game.playState != PlayState.playing) return;

    // Швидкість (можна винести в config.dart)
    // 800 - це досить швидкий і приємний рух
    const double speed = 800.0;

    if (game.keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      // Рух вліво: швидкість * час кадру
      position.x -= speed * dt;
    } else if (game.keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      // Рух вправо
      position.x += speed * dt;
    }

    // Обмежуємо, щоб біта не вилітала за екран
    // clamp(мінімум, максимум)
    position.x = position.x.clamp(size.x / 2, game.width - size.x / 2);
  }

  // void moveBy(double dx) {
  //   add(
  //     MoveToEffect(
  //       Vector2((position.x + dx).clamp(0, game.width), position.y),
  //       EffectController(duration: 0.1),
  //     ),
  //   );
  // }
}
