shader_type spatial;

uniform sampler2D wall_texture : source_color;
uniform float brightness : hint_range(0.0f, 1.0f) = 1.0f;
uniform float alpha : hint_range(0.0f, 1.0f) = 1.0f;

varying vec3 some_color;
varying vec3 world_pos;

void vertex() {
	some_color = NORMAL;
	world_pos = VERTEX;
}

vec3 random(vec3 coord)
{
	vec3 res;
	res.x = fract(sin(dot(coord.yz, vec2(12.9898,78.233))) * 43758.5453123);
	res.y = fract(sin(dot(coord.xz, vec2(16.6539,68.698))) * 69845.5962848);
	res.z = fract(sin(dot(coord.xy, vec2(25.5263,41.256))) * 42538.6985436);
	return res;
}

void fragment() {
	if (some_color.g > .5f)
	{
		ALBEDO = vec3(0,0,0);
	}
	else
	{
		vec4 projected_coords = INV_VIEW_MATRIX * vec4(VERTEX, 1.0);
		vec3 albedoX = texture(wall_texture, projected_coords.zy).rgb;
		vec3 albedoY = texture(wall_texture, projected_coords.xz).rgb;
		vec3 albedoZ = texture(wall_texture, projected_coords.xy).rgb;
		vec3 world_normal = abs(INV_VIEW_MATRIX * vec4(NORMAL, 0.0)).xyz;
		vec3 normal_weights = world_normal / (world_normal.x + world_normal.y + world_normal.z);

		vec3 color_offset = random(floor(projected_coords.xyz));

		ALBEDO = mix(vec3(0.0f), mix((albedoX * normal_weights.x + albedoY * normal_weights.y + albedoZ * normal_weights.z), color_offset.rgb, 0.05f), brightness);
		ALPHA = alpha;
	}
}
