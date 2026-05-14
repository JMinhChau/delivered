# Art Slots

For the main drive art, open the scene, click the named `Sprite2D`, and replace its `Texture` in the Inspector.

For the scrolling drive view:

- `RoadLayer/SkySprite`: full sky texture.
- `RoadLayer/ParallaxFarA`: distant background layer. The game loops this one sprite at runtime.
- `RoadLayer/ParallaxNearA`: closer parallax layer. The game loops this one sprite at runtime.
- `RoadLayer/RoadTiles/RoadTileA`: scrolling road tile. The game loops this one sprite at runtime.
- `Obstacle/Sprite2D` in `obstacle.tscn`: normal traffic car art.
- `Ambulance/Sprite2D` in `ambulance.tscn`: ambulance art.
- `Drunkard/Sprite2D` in `drunkard.tscn`: wandering car art.

If a sprite has no texture, the game keeps the old block placeholder visible.

## Path-Based Slots

- `drive/gas_pickup.png`
- `drive/hole.png`
- `drive/ramp.png`
- `drive/barricade.png`

## Town

- `town/background.png`
- `town/momo.png`
- `town/pip.png`
- `town/benne.png`
- `town/lou.png`
- `town/momo_face.png`
- `town/pip_face.png`
- `town/benne_face.png`
- `town/lou_face.png`

## Story And Menu

- `story/boss_background.png`
- `story/intro_background.png`
- `story/end_background.png`
- `story/mr_gus.png`
- `story/mr_gus_face.png`
- `story/k_face.png`
- `story/player_face.png`
- `menu/background.png`
- `menu/road_strip.png`
