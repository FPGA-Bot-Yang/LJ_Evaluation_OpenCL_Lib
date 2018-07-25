float4 LJ_Force_hdl(float ref_x, float ref_y, float ref_z, float neighbor_x, float neighbor_y, float neighbor_z)
{
	
	printf("Disclaimer: This emulation model just serve as a place holder provided by Chen Yang, the results may not 100% reflects the on board running result!\n");
	// the logic here is not what the custom func is doing, don't use this result for verification
	float dx = ref_x - neighbor_x;
	float dy = ref_y - neighbor_y;
	float dz = ref_z - neighbor_z;
	float r2 = dx*dx + dy*dy + dz*dz;
	
	float inv_r2 = 1 / r2;
	float inv_r4 = inv_r2 * inv_r2;
	float inv_r8 = inv_r4 * inv_r4;
	float inv_r14 = inv_r8 * inv_r4 * inv_r2;
	
	float LJ_Force = 48*inv_r14 - 24*inv_r8;
	
	float LJ_Force_x = LJ_Force * dx;
	float LJ_Force_y = LJ_Force * dy;
	float LJ_Force_z = LJ_Force * dz;
	
	float4 LJ_Force_Components = (float4)(0.0f, LJ_Force_z, LJ_Force_y, LJ_Force_x);
	return LJ_Force_Components;
}
