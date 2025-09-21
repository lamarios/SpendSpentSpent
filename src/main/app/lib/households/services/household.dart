import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spend_spent_spent/households/models/household_enums.dart';
import 'package:spend_spent_spent/households/models/household_members.dart';
import 'package:spend_spent_spent/service.dart';

import '../models/household.dart';

extension HouseholdService on Service {
  Future<Household> createHousehold() async {
    final response = await http.put(
      await formatUrl('$API_URL/Household'),
      headers: await headers,
    );

    processResponse(response);

    return Household.fromJson(jsonDecode(response.body));
  }

  Future<Household?> getHousehold() async {
    final response = await http.get(
      await formatUrl('$API_URL/Household'),
      headers: await headers,
    );

    print('body: ${response.body}');
    processResponse(response);
    if (response.body.trim().isEmpty) {
      return null;
    }
    return Household.fromJson(jsonDecode(response.body));
  }

  Future<void> inviteUser(String email) async {
    final response = await http.get(
      await formatUrl(
        '$API_URL/Household/invites/${Uri.encodeComponent(email)}',
      ),
      headers: await headers,
    );

    processResponse(response);
  }

  Future<Household> acceptInvitation(String invitationId) async {
    final response = await http.get(
      await formatUrl('$API_URL/Household/invites/$invitationId/accept'),
      headers: await headers,
    );

    processResponse(response);

    return Household.fromJson(jsonDecode(response.body));
  }

  Future<List<HouseholdMembers>> getInvitations() async {
    final response = await http.get(
      await formatUrl('$API_URL/Household/invites'),
      headers: await headers,
    );

    processResponse(response);

    Iterable res = jsonDecode(response.body);

    return List<HouseholdMembers>.from(
      res.map((e) => HouseholdMembers.fromJson(e)),
    );
  }

  Future<void> leaveHousehold() async {
    final response = await http.delete(
      await formatUrl('$API_URL/Household/leave'),
      headers: await headers,
    );

    processResponse(response);
  }

  Future<void> deleteHousehold() async {
    final response = await http.delete(
      await formatUrl('$API_URL/Household'),
      headers: await headers,
    );

    processResponse(response);
  }

  Future<void> setMemberAdmin({
    required String userId,
    required bool isAdmin,
  }) async {
    final response = await http.post(
      await formatUrl('$API_URL/Household/set-admin/$userId'),
      headers: await headers,
      body: jsonEncode(isAdmin),
    );

    processResponse(response);
  }

  Future<void> setColor(HouseholdColor color) async {
    final response = await http.post(
      await formatUrl('$API_URL/Household/set-color'),
      headers: await headers,
      body: jsonEncode(color.name),
    );

    processResponse(response);
  }

  Future<void> removeUserFromHousehold(String userId) async {
    final response = await http.delete(
      await formatUrl('$API_URL/Household/$userId'),
      headers: await headers,
    );

    processResponse(response);
  }
}
