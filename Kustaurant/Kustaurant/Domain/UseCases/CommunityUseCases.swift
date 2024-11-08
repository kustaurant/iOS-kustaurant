//
//  CommunityUseCases.swift
//  Kustaurant
//
//  Created by 송우진 on 10/13/24.
//

import Foundation

protocol CommunityUseCases {
    func fetchPosts(category: CommunityPostCategory, page: Int, sort: CommunityPostSortType) async -> Result<[CommunityPostDTO], NetworkError>
    func fetchPostDetail(postId: Int) async -> Result<CommunityPostDTO, NetworkError>
    func postDetailLikeToggle(postId: Int) async -> Result<CommunityLikeStatus, NetworkError>
    func postDetailScrapToggle(postId: Int) async -> Result<CommunityScrapStatus, NetworkError>
    func commentActionToggle(commentId: Int, action: CommentActionType) async -> Result<CommunityCommentStatus, NetworkError>
    func deleteComment(commentId: Int) async -> Result<Void, NetworkError>
    func uploadImage(_ data: CommunityPostWriteData) async -> Result<String, NetworkError>
    func createPost(_ data: CommunityPostWriteData) async -> Result<CommunityPostDTO, NetworkError>
    func deletePost(postId: Int) async -> Result<Void, NetworkError>
}

final class DefaultCommunityUseCases {
    private let communityRepository: CommunityRepository

    init(communityRepository: CommunityRepository) {
        self.communityRepository = communityRepository
    }
}

extension DefaultCommunityUseCases: CommunityUseCases {
    func deletePost(postId: Int) async -> Result<Void, NetworkError> {
        await communityRepository.deletePost(postId: postId)
    }
    
    func uploadImage(_ data: CommunityPostWriteData) async -> Result<String, NetworkError> {
        let imageData = await data.imageData
        return await communityRepository.uploadImage(imageData: imageData)
    }
    
    func createPost(_ data: CommunityPostWriteData) async -> Result<CommunityPostDTO, NetworkError> {
        guard 
            let title = await data.title,
            let content = await data.content
        else {
            return .failure(.custom("null data"))
        }
        let (category, imageFile) = await (data.category, data.imageFile)
        return await communityRepository.createPost(
            title: title,
            postCategory: String(describing: category),
            content: content,
            imageFile: imageFile
        )
    }
    
    func deleteComment(commentId: Int) async -> Result<Void, NetworkError> {
        await communityRepository.deleteCommunityComment(commentId: commentId)
    }
    
    func commentActionToggle(
        commentId: Int,
        action: CommentActionType
    ) async -> Result<CommunityCommentStatus, NetworkError> {
        await communityRepository.postCommunityCommentLikeToggle(commentId: commentId, action: action)
    }
    
    func postDetailScrapToggle(postId: Int) async -> Result<CommunityScrapStatus, NetworkError> {
        await communityRepository.postCommunityPostScrapToggle(postId: postId)
    }
    
    func postDetailLikeToggle(postId: Int) async -> Result<CommunityLikeStatus, NetworkError> {
        await communityRepository.postCommunityPostLikeToggle(postId: postId)
    }
    
    func fetchPostDetail(postId: Int) async -> Result<CommunityPostDTO, NetworkError> {
        await communityRepository.getPostDetail(postId: postId)
    }
    
    func fetchPosts(
        category: CommunityPostCategory,
        page: Int,
        sort: CommunityPostSortType
    ) async -> Result<[CommunityPostDTO], NetworkError> {
        await communityRepository.getPosts(category: category, page: page, sort: sort)
    }
    
    
}
