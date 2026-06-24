import 'package:sortirin/features/rewards/data/models/reward_model.dart';
import 'package:sortirin/features/rewards/data/models/redemption_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RewardRemoteDataSource {
  final SupabaseClient _client;
  RewardRemoteDataSource(this._client);

  Future<List<RewardModel>> getRewards({String? category}) async {
    var query = _client.from('rewards').select().eq('is_active', true);
    if (category != null) query = query.eq('category', category);
    final data = await query;
    return (data as List).map((e) => RewardModel.fromJson(e)).toList();
  }

  Future<RewardModel> getRewardById(int id) async {
    final data = await _client.from('rewards').select().eq('id', id).single();
    return RewardModel.fromJson(data);
  }

  Future<RedemptionModel> redeemReward({
    required String userId, required int rewardId, required int pointsCost,
  }) async {
    final inserted = await _client.from('redemptions').insert({
      'user_id': userId, 'reward_id': rewardId,
      'points_spent': pointsCost, 'status': 'pending',
    }).select('*, rewards(name)').single();
    return RedemptionModel.fromJson(inserted);
  }

  Future<List<RedemptionModel>> getRedemptionHistory(String userId) async {
    final data = await _client
        .from('redemptions')
        .select('*, rewards(name)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return (data as List).map((e) => RedemptionModel.fromJson(e)).toList();
  }
}
