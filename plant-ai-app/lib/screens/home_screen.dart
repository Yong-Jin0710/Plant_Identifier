import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.apiService});

  final ApiService apiService;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  File? _imageFile;
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _analysisResult;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (picked == null) {
        return;
      }

      setState(() {
        _imageFile = File(picked.path);
        _analysisResult = null;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '이미지 선택 중 오류가 발생했습니다: $e';
      });
    }
  }

  Future<void> _analyzePlant() async {
    if (_imageFile == null) {
      setState(() {
        _errorMessage = '먼저 식물 사진을 촬영하거나 선택해 주세요.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await widget.apiService.analyzePlant(_imageFile!);
      setState(() {
        _analysisResult = result;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'AI 분석 중 오류가 발생했습니다: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final plant = _analysisResult?['plant'] as Map<String, dynamic>?;
    final commonNames = (plant?['commonNames'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();
    final alternatives = _analysisResult?['alternatives'] as List<dynamic>? ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('식물 사진 AI 분석')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 260,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              clipBehavior: Clip.antiAlias,
              child: _imageFile == null
                  ? const Center(child: Text('사진이 아직 없습니다.'))
                  : Image.file(_imageFile!, fit: BoxFit.cover),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    child: const Text('사진찍기'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    child: const Text('갤러리 선택'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading ? null : _analyzePlant,
              child: _isLoading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('AI 분석하기'),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            if (_analysisResult != null) ...[
              const SizedBox(height: 18),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '분석 결과',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('학명: ${plant?['scientificName'] ?? '알 수 없음'}'),
                      Text('과: ${plant?['family'] ?? '알 수 없음'}'),
                      Text('속: ${plant?['genus'] ?? '알 수 없음'}'),
                      Text(
                        '일반명: ${commonNames.isEmpty ? '알 수 없음' : commonNames.join(', ')}',
                      ),
                      Text('신뢰도: ${_analysisResult?['rawScore'] ?? '-'}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (alternatives.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '대체 후보',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        for (final item in alternatives)
                          Text(
                            '- ${item['scientificName'] ?? '이름 없음'} (점수: ${item['score'] ?? '-'})',
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
